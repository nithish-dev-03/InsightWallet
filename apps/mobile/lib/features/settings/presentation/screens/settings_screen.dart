import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/shared/widgets/section_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (settings) => ListView(
          padding: const EdgeInsets.all(Insets.md),
          children: [
            _AppearanceSection(settings: settings),
            const SizedBox(height: Insets.md),
            _CurrencySection(settings: settings),
            const SizedBox(height: Insets.md),
            _NotificationsSection(settings: settings),
            const SizedBox(height: Insets.md),
            _PrivacySection(settings: settings),
            const SizedBox(height: Insets.md),
            _DataSection(),
            const SizedBox(height: Insets.md),
            _AboutSection(),
            const SizedBox(height: Insets.xl),
          ],
        ),
      ),
    );
  }
}

class _AppearanceSection extends ConsumerWidget {
  final dynamic settings;

  const _AppearanceSection({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Appearance'),
        const SizedBox(height: Insets.xs),
        GlassCard(
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.brightness_6,
                title: 'Theme',
                trailing: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'light', label: Text('Light')),
                    ButtonSegment(value: 'dark', label: Text('Dark')),
                    ButtonSegment(value: 'system', label: Text('System')),
                  ],
                  selected: {settings.theme},
                  onSelectionChanged: (v) {
                    ref.read(settingsProvider.notifier).updateTheme(v.first);
                  },
                ),
              ),
              const Divider(
                height: 1,
                color: AppColors.darkOutlineVariant,
                indent: Insets.lg,
              ),
              _SettingsTile(
                icon: Icons.language,
                title: 'Language',
                trailing: DropdownButton<String>(
                  value: settings.language,
                  underline: const SizedBox(),
                  dropdownColor: AppColors.darkSurface,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'es', child: Text('Spanish')),
                    DropdownMenuItem(value: 'fr', child: Text('French')),
                    DropdownMenuItem(value: 'de', child: Text('German')),
                    DropdownMenuItem(value: 'pt', child: Text('Portuguese')),
                    DropdownMenuItem(value: 'ja', child: Text('Japanese')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .updateLanguage(v);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CurrencySection extends ConsumerWidget {
  final dynamic settings;

  const _CurrencySection({required this.settings});

  static const _currencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY',
    'INR', 'BRL', 'KRW', 'MXN', 'SGD', 'HKD', 'NZD',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Currency'),
        const SizedBox(height: Insets.xs),
        GlassCard(
          child: SizedBox(
            height: 160,
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
                final isSelected = currency == settings.currency;
                return GestureDetector(
                  onTap: () => ref
                      .read(settingsProvider.notifier)
                      .updateCurrency(currency),
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
                        color: isSelected
                            ? Colors.white
                            : AppColors.darkOnSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationsSection extends ConsumerWidget {
  final dynamic settings;

  const _NotificationsSection({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = settings.notifications;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Notifications'),
        const SizedBox(height: Insets.xs),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _SettingsSwitchTile(
                icon: Icons.wallet,
                title: 'Budget Alerts',
                subtitle: 'Get notified when approaching budget limits',
                value: n.budgetAlerts,
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .toggleNotification('budgetAlerts', v),
              ),
              _SettingsSwitchTile(
                icon: Icons.flag,
                title: 'Goal Reminders',
                subtitle: 'Reminders for savings goals',
                value: n.goalReminders,
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .toggleNotification('goalReminders', v),
              ),
              _SettingsSwitchTile(
                icon: Icons.summarize,
                title: 'Monthly Summary',
                subtitle: 'Receive monthly spending summary',
                value: n.monthlySummary,
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .toggleNotification('monthlySummary', v),
              ),
              _SettingsSwitchTile(
                icon: Icons.auto_awesome,
                title: 'AI Insights',
                subtitle: 'Personalized spending insights',
                value: n.insights,
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .toggleNotification('insights', v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrivacySection extends ConsumerWidget {
  final dynamic settings;

  const _PrivacySection({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = settings.privacy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Privacy'),
        const SizedBox(height: Insets.xs),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _SettingsSwitchTile(
                icon: Icons.visibility,
                title: 'Show Balance',
                subtitle: 'Display balance on home screen',
                value: p.showBalance,
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .togglePrivacy('showBalance', v),
              ),
              _SettingsSwitchTile(
                icon: Icons.receipt_long,
                title: 'Show Transactions',
                subtitle: 'Display recent transactions on home screen',
                value: p.showTransactions,
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .togglePrivacy('showTransactions', v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DataSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Data'),
        const SizedBox(height: Insets.xs),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.download,
                title: 'Export Data',
                trailing: DropdownButton<String>(
                  value: ref.watch(settingsProvider).valueOrNull?.exportFormat ?? 'csv',
                  underline: const SizedBox(),
                  dropdownColor: AppColors.darkSurface,
                  items: const [
                    DropdownMenuItem(value: 'csv', child: Text('CSV')),
                    DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .updateExportFormat(v);
                    }
                  },
                ),
                onTap: () {},
              ),
              const Divider(
                height: 1,
                color: AppColors.darkOutlineVariant,
                indent: Insets.lg,
              ),
              _SettingsTile(
                icon: Icons.delete_sweep,
                title: 'Clear Cache',
                onTap: () {
                  ref.read(settingsProvider.notifier).clearCache();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'About'),
        SizedBox(height: Insets.xs),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'App Version',
                trailing: Text(
                  '1.0.0',
                  style: TextStyle(color: AppColors.darkOnSurfaceVariant),
                ),
              ),
              Divider(
                height: 1,
                color: AppColors.darkOutlineVariant,
                indent: Insets.lg,
              ),
              _SettingsTile(
                icon: Icons.description,
                title: 'Open Source Licenses',
              ),
              Divider(
                height: 1,
                color: AppColors.darkOutlineVariant,
                indent: Insets.lg,
              ),
              _SettingsTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
              ),
              Divider(
                height: 1,
                color: AppColors.darkOutlineVariant,
                indent: Insets.lg,
              ),
              _SettingsTile(
                icon: Icons.article,
                title: 'Terms of Service',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.bodyMd),
                  if (subtitle != null) ...[
                    const SizedBox(height: Insets.xs),
                    Text(
                      subtitle!,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.darkOnSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: Insets.sm,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.darkOnSurfaceVariant, size: 22),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMd),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.darkOnSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Insets.sm),
          Switch(
            value: value,
            activeThumbColor: AppColors.darkPrimary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
