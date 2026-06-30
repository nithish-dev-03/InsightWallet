import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/shared/widgets/loading_shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return AppScaffold(
      body: profileAsync.when(
        loading: () => const _ProfileShimmer(),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.darkError),
                const SizedBox(height: Insets.md),
                Text(
                  'Failed to load profile',
                  style: AppTypography.bodyLg,
                ),
                const SizedBox(height: Insets.md),
                FilledButton(
                  onPressed: () => ref.invalidate(profileProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (profile) => ListView(
          padding: const EdgeInsets.all(Insets.md),
          children: [
            const SizedBox(height: Insets.lg),
            _AvatarSection(profile: profile),
            const SizedBox(height: Insets.lg),
            _StatisticsRow(),
            const SizedBox(height: Insets.lg),
            _ProfileActions(profile: profile),
            const SizedBox(height: Insets.lg),
            _LogoutButton(),
            const SizedBox(height: Insets.lg),
            Center(
              child: Text(
                'InsightWallet v1.0.0',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.darkOnSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: Insets.xl),
          ],
        ),
      ),
    );
  }
}

class _AvatarSection extends ConsumerWidget {
  final dynamic profile;

  const _AvatarSection({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _pickImage(ref),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: AppColors.darkSurfaceContainerHigh,
                  backgroundImage: profile.avatar != null
                      ? NetworkImage(profile.avatar!)
                      : null,
                  child: profile.avatar == null
                      ? Text(
                          profile.name.isNotEmpty
                              ? profile.name[0].toUpperCase()
                              : '?',
                          style: AppTypography.displayLgMobile.copyWith(
                            color: AppColors.darkPrimary,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(Insets.sm),
                    decoration: const BoxDecoration(
                      color: AppColors.darkPrimaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Insets.md),
          Text(
            profile.name,
            style: AppTypography.headlineMd,
          ),
          const SizedBox(height: Insets.xs),
          Text(
            profile.email,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.darkOnSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      ref.read(profileProvider.notifier).uploadAvatar(picked.path);
    }
  }
}

class _StatisticsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _MiniStatCard(
            label: 'Transactions',
            value: '128',
            icon: Icons.swap_horiz,
            color: AppColors.darkPrimary,
          ),
        ),
        SizedBox(width: Insets.sm),
        Expanded(
          child: _MiniStatCard(
            label: 'Income',
            value: '\$4.2k',
            icon: Icons.arrow_upward,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: Insets.sm),
          Text(
            value,
            style: AppTypography.numberXl.copyWith(
              fontSize: 24,
              color: color,
            ),
          ),
          const SizedBox(height: Insets.xs),
          Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.darkOnSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActions extends ConsumerWidget {
  final dynamic profile;

  const _ProfileActions({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.fingerprint,
            title: 'Biometric Lock',
            trailing: Switch(
              value: profile.biometricEnabled,
              activeColor: AppColors.darkPrimary,
              onChanged: (v) =>
                  ref.read(profileProvider.notifier).toggleBiometric(v),
            ),
          ),
          const Divider(
            height: 1,
            color: AppColors.darkOutlineVariant,
            indent: Insets.lg,
          ),
          _ActionTile(
            icon: Icons.download,
            title: 'Export Data',
            onTap: () {},
          ),
          const Divider(
            height: 1,
            color: AppColors.darkOutlineVariant,
            indent: Insets.lg,
          ),
          _ActionTile(
            icon: Icons.account_circle,
            title: 'Account Details',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.brXl,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.md,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.darkOnSurfaceVariant, size: 22),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyMd,
              ),
            ),
            if (trailing != null)
              trailing!
            else
              const Icon(
                Icons.chevron_right,
                color: AppColors.darkOnSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppColors.darkSurface,
              title: const Text('Sign Out'),
              content: const Text('Are you sure you want to sign out?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ref.read(profileProvider.notifier).logout();
                  },
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: AppColors.darkError),
                  ),
                ),
              ],
            ),
          );
        },
        borderRadius: AppRadius.brXl,
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Insets.md,
            vertical: Insets.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: AppColors.darkError, size: 20),
              SizedBox(width: Insets.sm),
              Text(
                'Sign Out',
                style: TextStyle(
                  color: AppColors.darkError,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
