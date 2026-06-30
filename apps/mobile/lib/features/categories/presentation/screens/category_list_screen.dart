import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../providers/category_provider.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load categories',
                style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: Insets.md),
              FilledButton(
                onPressed: () => ref.invalidate(categoryProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (categories) {
          final incomeCategories =
              categories.where((c) => c.type == 'income').toList();
          final expenseCategories =
              categories.where((c) => c.type == 'expense').toList();

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => ref.read(categoryProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(Insets.md),
              children: [
                if (incomeCategories.isNotEmpty) ...[
                  Text(
                    'Income',
                    style: AppTypography.headlineSm.copyWith(color: AppColors.onSurface),
                  ),
                  const SizedBox(height: Insets.sm),
                  _buildCategoryGrid(incomeCategories),
                  const SizedBox(height: Insets.lg),
                ],
                if (expenseCategories.isNotEmpty) ...[
                  Text(
                    'Expense',
                    style: AppTypography.headlineSm.copyWith(color: AppColors.onSurface),
                  ),
                  const SizedBox(height: Insets.sm),
                  _buildCategoryGrid(expenseCategories),
                ],
                if (categories.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(Insets.xl),
                      child: Text('No categories available'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryGrid(List<CategoryEntity> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: Insets.sm,
        mainAxisSpacing: Insets.sm,
        childAspectRatio: 0.9,
      ),
      itemCount: categories.length,
      itemBuilder: (_, index) {
        final category = categories[index];
        return _CategoryCard(category: category);
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryEntity category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(category.color);

    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadius.brMd,
            ),
            child: Icon(
              _categoryIcon(category.icon),
              size: 22,
              color: color,
            ),
          ),
          const SizedBox(height: Insets.sm),
          Text(
            category.name,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurface,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }
    return AppColors.primary;
  }

  IconData _categoryIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
      case 'food':
        return Icons.restaurant_rounded;
      case 'directions_car':
      case 'transport':
        return Icons.directions_car_rounded;
      case 'shopping_bag':
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'movie':
      case 'entertainment':
        return Icons.movie_rounded;
      case 'receipt_long':
      case 'bills':
        return Icons.receipt_long_rounded;
      case 'work':
      case 'salary':
        return Icons.work_rounded;
      case 'code':
      case 'freelance':
        return Icons.code_rounded;
      case 'trending_up':
      case 'investment':
        return Icons.trending_up_rounded;
      case 'favorite':
      case 'health':
        return Icons.favorite_rounded;
      case 'school':
      case 'education':
        return Icons.school_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
