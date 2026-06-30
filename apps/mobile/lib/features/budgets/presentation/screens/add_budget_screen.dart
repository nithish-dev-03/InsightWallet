import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/budget_entity.dart';
import '../providers/budget_provider.dart';

class AddBudgetScreen extends ConsumerStatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  late BudgetPeriod _period;
  bool _notifications = true;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  String _selectedCategory = 'Food';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Health',
    'Education',
    'Housing',
  ];

  final Map<String, IconData> _categoryIcons = {
    'Food': Icons.restaurant_rounded,
    'Transport': Icons.directions_car_rounded,
    'Shopping': Icons.shopping_bag_rounded,
    'Entertainment': Icons.movie_rounded,
    'Bills': Icons.receipt_long_rounded,
    'Health': Icons.local_hospital_rounded,
    'Education': Icons.school_rounded,
    'Housing': Icons.home_rounded,
  };

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _period = BudgetPeriod.monthly;
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(picked)) {
            _endDate = picked.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final budget = BudgetEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        categoryId: _selectedCategory.toLowerCase(),
        categoryName: _selectedCategory,
        amount: double.parse(_amountController.text),
        period: _period,
        startDate: _startDate,
        endDate: _endDate,
        notifications: _notifications,
      );

      await ref.read(budgetsProvider.notifier).addBudget(budget);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create budget: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Add Budget'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category', style: AppTypography.bodyMd),
              const SizedBox(height: Insets.sm),
              GlassCard(
                child: Wrap(
                  spacing: Insets.sm,
                  runSpacing: Insets.sm,
                  children: _categories.map((cat) {
                    final selected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Insets.md,
                          vertical: Insets.sm,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.darkPrimaryContainer
                              : AppColors.darkSurfaceVariant,
                          borderRadius: AppRadius.brMd,
                          border: selected
                              ? Border.all(
                                  color: AppColors.darkPrimary, width: 1)
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _categoryIcons[cat],
                              size: 16,
                              color: selected
                                  ? AppColors.darkOnPrimary
                                  : AppColors.darkOnSurfaceVariant,
                            ),
                            const SizedBox(width: Insets.xs),
                            Text(
                              cat,
                              style: AppTypography.bodySm.copyWith(
                                color: selected
                                    ? AppColors.darkOnPrimary
                                    : AppColors.darkOnSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: Insets.md),
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: AppTypography.numberXl,
                decoration: InputDecoration(
                  labelText: 'Budget Amount',
                  prefixText: '\$ ',
                  prefixStyle: AppTypography.numberXl,
                  filled: true,
                  fillColor: AppColors.darkSurface,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.brMd,
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter an amount';
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: Insets.md),
              Text('Period', style: AppTypography.bodyMd),
              const SizedBox(height: Insets.sm),
              GlassCard(
                child: SegmentedButton<BudgetPeriod>(
                  segments: const [
                    ButtonSegment(
                        value: BudgetPeriod.weekly, label: Text('Weekly')),
                    ButtonSegment(
                        value: BudgetPeriod.monthly, label: Text('Monthly')),
                    ButtonSegment(
                        value: BudgetPeriod.yearly, label: Text('Yearly')),
                  ],
                  selected: {_period},
                  onSelectionChanged: (set) => setState(() => _period = set.first),
                ),
              ),
              const SizedBox(height: Insets.md),
              Text('Date Range', style: AppTypography.bodyMd),
              const SizedBox(height: Insets.sm),
              GlassCard(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickDate(true),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start',
                                style: AppTypography.bodySm.copyWith(
                                    color: AppColors.darkOnSurfaceVariant)),
                            Text(
                              '${_startDate.month}/${_startDate.day}/${_startDate.year}',
                              style: AppTypography.bodyMd,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.sm),
                      child: Icon(Icons.arrow_forward_rounded,
                          color: AppColors.darkOnSurfaceVariant),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickDate(false),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('End',
                                style: AppTypography.bodySm.copyWith(
                                    color: AppColors.darkOnSurfaceVariant)),
                            Text(
                              '${_endDate.month}/${_endDate.day}/${_endDate.year}',
                              style: AppTypography.bodyMd,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Insets.md),
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notifications',
                            style: AppTypography.bodyMd),
                        Text('Get alerts when nearing limit',
                            style: AppTypography.bodySm.copyWith(
                                color: AppColors.darkOnSurfaceVariant)),
                      ],
                    ),
                    Switch(
                      value: _notifications,
                      onChanged: (v) => setState(() => _notifications = v),
                      activeColor: AppColors.darkPrimary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Insets.lg),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.darkPrimaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.brMd,
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Create Budget',
                          style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
