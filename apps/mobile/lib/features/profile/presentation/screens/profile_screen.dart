import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/shared/widgets/loading_shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/profile_provider.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const ListShimmer(itemCount: 5),
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
                    style: AppTypography.bodyLg.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
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
          data: (profile) => _ProfileContent(profile: profile),
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerStatefulWidget {
  final ProfileEntity profile;

  const _ProfileContent({required this.profile});

  @override
  ConsumerState<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends ConsumerState<_ProfileContent> {
  bool _tfaEnabled = true;
  bool _budgetLimits = true;
  bool _priceDrops = false;
  bool _emailReports = true;
  late bool _darkMode;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!_initialized) {
      _darkMode = isDark;
      _initialized = true;
    }
    final textPrimary = isDark ? Colors.white : AppColors.lightOnSurface;
    final textSecondary = isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant;

    final primaryColor = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);

    return ListView(
      padding: const EdgeInsets.only(bottom: Insets.xxl),
      children: [
        _buildAppBar(context, textPrimary, isDark),
        _buildUserHeader(context, isDark),
        const SizedBox(height: Insets.lg),
        _buildStatsGrid(context, isDark),
        const SizedBox(height: Insets.lg),
        _buildSubscriptionCard(context, isDark, primaryColor),
        const SizedBox(height: Insets.lg),
        _buildSectionHeader(context, 'Security & Privacy'),
        _buildSecuritySection(context, isDark, primaryColor),
        const SizedBox(height: Insets.lg),
        _buildSectionHeader(context, 'Display'),
        _buildDisplaySection(context, isDark, primaryColor),
        const SizedBox(height: Insets.lg),
        _buildSectionHeader(context, 'Alerts'),
        _buildAlertsSection(context, isDark, primaryColor),
        const SizedBox(height: Insets.lg),
        _buildMilestonesSection(context, isDark),
        const SizedBox(height: Insets.xl),
        _buildLogoutButton(context, isDark),
        const SizedBox(height: Insets.md),
        Center(
          child: Text(
            'InsightWallet v1.0.0',
            style: AppTypography.bodySm.copyWith(
              color: textSecondary,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, Color textPrimary, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.md, Insets.md, Insets.md, Insets.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD),
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: Insets.sm),
              Text(
                'InsightWallet',
                style: AppTypography.headlineSm.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, bool isDark) {
    final name = widget.profile.name.isNotEmpty ? widget.profile.name : 'Alex Thompson';
    final email = widget.profile.email.isNotEmpty ? widget.profile.email : 'alex.thompson@insight.com';
    final primaryColor = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);

    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor,
                      width: 2.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: isDark ? const Color(0xFF221E28) : const Color(0xFFF0ECF9),
                    backgroundImage: widget.profile.avatar != null && widget.profile.avatar!.isNotEmpty
                        ? NetworkImage(widget.profile.avatar!)
                        : null,
                    child: widget.profile.avatar == null || widget.profile.avatar!.isEmpty
                        ? Text(
                            name[0].toUpperCase(),
                            style: AppTypography.headlineMd.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(Insets.xs + 2),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 14,
                      color: isDark ? const Color(0xFF3F008E) : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Insets.md),
        Text(
          name,
          style: AppTypography.headlineMd.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          email,
          style: AppTypography.bodyMd.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Insets.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
            borderRadius: AppRadius.brFull,
            border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
          ),
          child: Text(
            'PREMIUM MEMBER',
            style: AppTypography.labelMd.copyWith(
              color: isDark ? const Color(0xFFD2BBFF) : const Color(0xFF4F46E5),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: Insets.md),
        SizedBox(
          width: 140,
          height: 38,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: isDark ? const Color(0xFF3F008E) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.brFull),
              elevation: 0,
            ),
            child: Text(
              'Edit Profile',
              style: AppTypography.bodyMd.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, bool isDark) {
    final primaryColor = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final tertiaryColor = isDark ? const Color(0xFFFFB784) : const Color(0xFF713700);
    final secondaryContainer = isDark ? const Color(0xFF7C3AED) : const Color(0xFF4F46E5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: Insets.sm,
        mainAxisSpacing: Insets.sm,
        childAspectRatio: 1.45,
        children: [
          _buildStatCard(context, 'NET WORTH', '\$128.4k', primaryColor),
          _buildStatCard(context, 'SAVINGS RATE', '34%', tertiaryColor),
          _buildStatCard(context, 'ACHIEVEMENTS', '12/20', secondaryContainer),
          _buildStatCard(context, 'SCORE', '782', primaryColor),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color accentColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF221E28) : const Color(0xFFF0ECF9).withValues(alpha: 0.6),
        borderRadius: AppRadius.brLg,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      padding: const EdgeInsets.all(Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTypography.labelMd.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: Insets.xs),
          Text(
            value,
            style: AppTypography.numberXl.copyWith(
              fontWeight: FontWeight.w800,
              color: accentColor,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(BuildContext context, bool isDark, Color primaryColor) {
    final isDarkCardColor = isDark ? const Color(0xFF221E28) : const Color(0xFFF0ECF9);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkCardColor,
          borderRadius: AppRadius.brXl,
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.3),
          ),
        ),
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subscription Status',
              style: AppTypography.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Insets.sm),
            Text(
              'You are currently on the Alpha/Pro annual plan. Next renewal is on Oct 31, 2024.',
              style: AppTypography.bodyMd.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Insets.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  side: BorderSide(
                    color: primaryColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'Manage Billing',
                  style: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.md + 4, Insets.md, Insets.md, Insets.xs),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.labelMd.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context, bool isDark, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _buildListTile(
              context,
              icon: Icons.fingerprint_rounded,
              title: 'Biometric Login',
              subtitle: 'Use Face ID or Fingerprint',
              trailing: Switch(
                value: widget.profile.biometricEnabled,
                activeThumbColor: primaryColor,
                activeTrackColor: primaryColor.withValues(alpha: 0.5),
                onChanged: (v) => ref.read(profileProvider.notifier).toggleBiometric(v),
              ),
            ),
            const Divider(height: 1, indent: 56),
            _buildListTile(
              context,
              icon: Icons.lock_outline_rounded,
              title: 'Two-Factor Auth',
              subtitle: 'Secure via SMS or App',
              trailing: Switch(
                value: _tfaEnabled,
                activeThumbColor: primaryColor,
                activeTrackColor: primaryColor.withValues(alpha: 0.5),
                onChanged: (v) => setState(() => _tfaEnabled = v),
              ),
            ),
            const Divider(height: 1, indent: 56),
            _buildListTile(
              context,
              icon: Icons.vpn_key_outlined,
              title: 'Change Password',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplaySection(BuildContext context, bool isDark, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _buildListTile(
              context,
              icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              title: 'Theme Mode',
              trailing: Switch(
                value: _darkMode,
                activeThumbColor: primaryColor,
                activeTrackColor: primaryColor.withValues(alpha: 0.5),
                onChanged: (v) {
                  setState(() => _darkMode = v);
                },
              ),
            ),
            const Divider(height: 1, indent: 56),
            _buildListTile(
              context,
              icon: Icons.monetization_on_outlined,
              title: 'Currency',
              subtitle: 'USD (\$)',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection(BuildContext context, bool isDark, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _buildListTile(
              context,
              icon: Icons.trending_down_rounded,
              title: 'Budget Limits',
              trailing: Switch(
                value: _budgetLimits,
                activeThumbColor: primaryColor,
                activeTrackColor: primaryColor.withValues(alpha: 0.5),
                onChanged: (v) => setState(() => _budgetLimits = v),
              ),
            ),
            const Divider(height: 1, indent: 56),
            _buildListTile(
              context,
              icon: Icons.sell_outlined,
              title: 'Price Drops',
              trailing: Switch(
                value: _priceDrops,
                activeThumbColor: primaryColor,
                activeTrackColor: primaryColor.withValues(alpha: 0.5),
                onChanged: (v) => setState(() => _priceDrops = v),
              ),
            ),
            const Divider(height: 1, indent: 56),
            _buildListTile(
              context,
              icon: Icons.email_outlined,
              title: 'Email Reports',
              trailing: Switch(
                value: _emailReports,
                activeThumbColor: primaryColor,
                activeTrackColor: primaryColor.withValues(alpha: 0.5),
                onChanged: (v) => setState(() => _emailReports = v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestonesSection(BuildContext context, bool isDark) {
    final activeColor = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);

    final badges = [
      {'label': 'Early Bird', 'icon': Icons.wb_sunny_outlined},
      {'label': 'Saver Pro', 'icon': Icons.savings_outlined},
      {'label': 'Debt Free', 'icon': Icons.verified_user_outlined},
      {'label': 'Wealth Builder', 'icon': Icons.domain_outlined},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Milestones',
                  style: AppTypography.headlineSm.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View All',
                    style: AppTypography.bodySm.copyWith(
                      color: activeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Insets.md),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: badges.length,
                itemBuilder: (ctx, index) {
                  final b = badges[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: activeColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: activeColor.withValues(alpha: 0.25), width: 1.5),
                          ),
                          child: Icon(b['icon'] as IconData, color: activeColor, size: 20),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          b['label'] as String,
                          style: AppTypography.bodySm.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isDark) {
    final dangerColor = isDark ? const Color(0xFFFFB4AB) : const Color(0xFFBA1A1A);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: InkWell(
        onTap: () => _handleLogout(context),
        borderRadius: AppRadius.brLg,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: dangerColor.withValues(alpha: 0.1),
            borderRadius: AppRadius.brLg,
            border: Border.all(color: dangerColor.withValues(alpha: 0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: dangerColor, size: 18),
              const SizedBox(width: Insets.sm),
              Text(
                'Logout from InsightWallet',
                style: TextStyle(
                  color: dangerColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.brXl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySm.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      ref.read(profileProvider.notifier).uploadAvatar(picked.path);
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
