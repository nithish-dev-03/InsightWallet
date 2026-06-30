import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goal_provider.dart';

class AddGoalScreen extends ConsumerStatefulWidget {
  const AddGoalScreen({super.key});

  @override
  ConsumerState<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends ConsumerState<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  late DateTime _deadline;
  IconData _selectedIcon = Icons.flag_rounded;
  Color _selectedColor = AppColors.darkPrimary;
  bool _isSubmitting = false;

  final List<IconData> _availableIcons = [
    Icons.flag_rounded,
    Icons.favorite_rounded,
    Icons.home_rounded,
    Icons.school_rounded,
    Icons.flight_takeoff_rounded,
    Icons.directions_car_rounded,
    Icons.shopping_cart_rounded,
    Icons.laptop_rounded,
    Icons.fitness_center_rounded,
    Icons.pets_rounded,
    Icons.weekend_rounded,
    Icons.card_giftcard_rounded,
  ];

  final List<Color> _availableColors = [
    AppColors.darkPrimary,
    AppColors.success,
    AppColors.expense,
    AppColors.warning,
    AppColors.info,
    const Color(0xFFec4899),
    const Color(0xFF14b8a6),
    const Color(0xFFf97316),
  ];

  @override
  void initState() {
    super.initState();
    _deadline = DateTime.now().add(const Duration(days: 365));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final goal = GoalEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        targetAmount: double.parse(_targetController.text),
        deadline: _deadline,
        icon: _selectedIcon,
        color: _selectedColor,
      );

      await ref.read(goalsProvider.notifier).addGoal(goal);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create goal: $e')),
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
        title: const Text('New Goal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                style: AppTypography.bodyLg,
                decoration: InputDecoration(
                  labelText: 'Goal Name',
                  hintText: 'e.g., Emergency Fund',
                  filled: true,
                  fillColor: AppColors.darkSurface,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.brMd,
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: Insets.md),
              TextFormField(
                controller: _targetController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: AppTypography.numberXl,
                decoration: InputDecoration(
                  labelText: 'Target Amount',
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
              Text('Deadline', style: AppTypography.bodyMd),
              const SizedBox(height: Insets.sm),
              GlassCard(
                onTap: _pickDeadline,
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        color: AppColors.darkPrimary),
                    const SizedBox(width: Insets.sm),
                    Expanded(
                      child: Text(
                        '${_deadline.month}/${_deadline.day}/${_deadline.year}',
                        style: AppTypography.bodyMd,
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.darkOnSurfaceVariant),
                  ],
                ),
              ),
              const SizedBox(height: Insets.md),
              Text('Icon', style: AppTypography.bodyMd),
              const SizedBox(height: Insets.sm),
              GlassCard(
                child: Wrap(
                  spacing: Insets.sm,
                  runSpacing: Insets.sm,
                  children: _availableIcons.map((icon) {
                    final selected = _selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = icon),
                      child: Container(
                        padding: const EdgeInsets.all(Insets.sm),
                        decoration: BoxDecoration(
                          color: selected
                              ? _selectedColor.withValues(alpha: 0.3)
                              : AppColors.darkSurfaceVariant,
                          borderRadius: AppRadius.brMd,
                          border: selected
                              ? Border.all(color: _selectedColor, width: 1)
                              : null,
                        ),
                        child: Icon(icon,
                            color: selected
                                ? _selectedColor
                                : AppColors.darkOnSurfaceVariant),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: Insets.md),
              Text('Color', style: AppTypography.bodyMd),
              const SizedBox(height: Insets.sm),
              GlassCard(
                child: Wrap(
                  spacing: Insets.sm,
                  runSpacing: Insets.sm,
                  children: _availableColors.map((color) {
                    final selected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: AppRadius.brFull,
                          border: selected
                              ? Border.all(
                                  color: AppColors.darkOnSurface, width: 2)
                              : null,
                        ),
                        child: selected
                            ? const Icon(Icons.check_rounded,
                                size: 18, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
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
                      : const Text('Create Goal',
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
