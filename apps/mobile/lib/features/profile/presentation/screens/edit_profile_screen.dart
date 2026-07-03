import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/profile_entity.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _selectedCurrency = 'USD';

  static const _currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
    'INR',
    'BRL',
    'KRW',
    'MXN',
    'SGD',
    'HKD',
    'NZD',
    'SEK',
    'NGN',
    'ZAR',
    'TRY',
    'RUB',
  ];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).valueOrNull;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _selectedCurrency = profile?.currency ?? 'USD';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: profileAsync.isLoading ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Insets.md),
        children: [
          _buildNameField(),
          const SizedBox(height: Insets.md),
          _buildEmailField(),
          const SizedBox(height: Insets.lg),
          _buildCurrencySelector(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Full Name',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.darkOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: Insets.xs),
          TextField(
            controller: _nameController,
            style: AppTypography.bodyLg,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your name',
              hintStyle: TextStyle(color: AppColors.darkOnSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.darkOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: Insets.xs),
          TextField(
            controller: _emailController,
            style: AppTypography.bodyLg,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your email',
              hintStyle: TextStyle(color: AppColors.darkOnSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Currency',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.darkOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: Insets.sm),
          SizedBox(
            height: 180,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: Insets.sm,
                crossAxisSpacing: Insets.sm,
                childAspectRatio: 1.5,
              ),
              itemCount: _currencies.length,
              itemBuilder: (context, index) {
                final currency = _currencies[index];
                final isSelected = currency == _selectedCurrency;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCurrency = currency),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.darkPrimaryContainer
                          : AppColors.darkSurfaceContainerHigh,
                      borderRadius: AppRadius.brMd,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.darkPrimary
                            : AppColors.darkOutlineVariant,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      currency,
                      style: AppTypography.bodySm.copyWith(
                        color:
                            isSelected ? Colors.white : AppColors.darkOnSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final current = ref.read(profileProvider).valueOrNull;
    if (current == null) return;

    final updated = ProfileEntity(
      id: current.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      avatar: current.avatar,
      currency: _selectedCurrency,
      theme: current.theme,
      emailVerified: current.emailVerified,
      biometricEnabled: current.biometricEnabled,
      createdAt: current.createdAt,
    );

    await ref.read(profileProvider.notifier).updateProfile(updated);
    if (mounted) Navigator.pop(context);
  }
}
