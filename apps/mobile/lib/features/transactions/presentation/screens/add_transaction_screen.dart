import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/utils/validators.dart';
import '../providers/transaction_provider.dart';
import '../providers/transaction_list_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();
  final _tagsController = TextEditingController();
  final _picker = ImagePicker();

  String _type = 'expense';
  String _selectedCategory = 'food';
  DateTime _selectedDate = DateTime.now();
  String? _receiptPath;
  bool _isSubmitting = false;

  final _categories = [
    ('food', Icons.restaurant_rounded, 'Food'),
    ('transport', Icons.directions_car_rounded, 'Transport'),
    ('shopping', Icons.shopping_bag_rounded, 'Shopping'),
    ('entertainment', Icons.movie_rounded, 'Entertainment'),
    ('bills', Icons.receipt_long_rounded, 'Bills'),
    ('salary', Icons.work_rounded, 'Salary'),
    ('freelance', Icons.code_rounded, 'Freelance'),
    ('investment', Icons.trending_up_rounded, 'Investment'),
    ('health', Icons.favorite_rounded, 'Health'),
    ('education', Icons.school_rounded, 'Education'),
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickReceipt() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _receiptPath = file.path);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final tags = _tagsController.text.isNotEmpty
        ? _tagsController.text.split(',').map((t) => t.trim()).toList()
        : <String>[];

    try {
      await ref.read(createTransactionProvider({
        'amount': double.parse(_amountController.text),
        'type': _type,
        'category': _selectedCategory,
        'description': _descriptionController.text.trim(),
        'date': _selectedDate.toIso8601String(),
        if (_noteController.text.isNotEmpty) 'note': _noteController.text.trim(),
        if (tags.isNotEmpty) 'tags': tags,
      }).future);

      if (mounted) {
        ref.invalidate(transactionListProvider);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _handleSubmit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeToggle(),
              const SizedBox(height: Insets.lg),
              GlassCard(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: Validators.amount,
                      style: AppTypography.numberXl.copyWith(
                        color: AppColors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        labelText: 'Amount',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        labelStyle: AppTypography.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Insets.lg),
              Text('Category', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(height: Insets.sm),
              _buildCategoryGrid(),
              const SizedBox(height: Insets.lg),
              GlassCard(
                child: Column(
                  children: [
                    _buildDateField(),
                    const Divider(height: 1),
                    TextFormField(
                      controller: _descriptionController,
                      validator: (v) => Validators.required(v, 'Description'),
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.edit_outlined),
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(height: 1),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Note (optional)',
                        prefixIcon: Icon(Icons.notes_rounded),
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(height: 1),
                    TextFormField(
                      controller: _tagsController,
                      decoration: const InputDecoration(
                        labelText: 'Tags (comma separated)',
                        prefixIcon: Icon(Icons.label_outline_rounded),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Insets.lg),
              Text('Receipt', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(height: Insets.sm),
              GlassCard(
                onTap: _pickReceipt,
                child: Row(
                  children: [
                    Icon(
                      _receiptPath != null
                          ? Icons.check_circle_rounded
                          : Icons.add_photo_alternate_outlined,
                      color: _receiptPath != null
                          ? AppColors.success
                          : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: Insets.sm),
                    Text(
                      _receiptPath != null
                          ? 'Receipt selected'
                          : 'Tap to add receipt image',
                      style: AppTypography.bodyMd.copyWith(
                        color: _receiptPath != null
                            ? AppColors.onSurface
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Insets.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return GlassCard(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _type = 'expense'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _type == 'expense'
                      ? AppColors.expense.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: AppRadius.brMd,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: 18,
                      color: _type == 'expense'
                          ? AppColors.expense
                          : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: Insets.sm),
                    Text(
                      'Expense',
                      style: AppTypography.bodyMd.copyWith(
                        color: _type == 'expense'
                            ? AppColors.expense
                            : AppColors.onSurfaceVariant,
                        fontWeight: _type == 'expense'
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _type = 'income'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _type == 'income'
                      ? AppColors.income.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: AppRadius.brMd,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_downward_rounded,
                      size: 18,
                      color: _type == 'income'
                          ? AppColors.income
                          : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: Insets.sm),
                    Text(
                      'Income',
                      style: AppTypography.bodyMd.copyWith(
                        color: _type == 'income'
                            ? AppColors.income
                            : AppColors.onSurfaceVariant,
                        fontWeight: _type == 'income'
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GlassCard(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: _categories.length,
        itemBuilder: (_, index) {
          final (key, icon, label) = _categories[index];
          final selected = _selectedCategory == key;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = key),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primaryContainer
                        : AppColors.surfaceContainerHighest,
                    borderRadius: AppRadius.brMd,
                    border: selected
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppTypography.bodySm.copyWith(
                    fontSize: 11,
                    color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _pickDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date',
          prefixIcon: Icon(Icons.calendar_today_rounded),
          border: InputBorder.none,
        ),
        child: Text(
          FormatUtils.formatAbsoluteDate(_selectedDate),
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
        ),
      ),
    );
  }
}
