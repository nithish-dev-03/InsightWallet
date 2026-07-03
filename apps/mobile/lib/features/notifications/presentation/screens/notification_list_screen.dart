import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/empty_state.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/notification_entity.dart';
import '../providers/notification_provider.dart';

enum _NotificationFilter { all, unread }

class NotificationListScreen extends ConsumerStatefulWidget {
  const NotificationListScreen({super.key});

  @override
  ConsumerState<NotificationListScreen> createState() =>
      _NotificationListScreenState();
}

class _NotificationListScreenState
    extends ConsumerState<NotificationListScreen> {
  _NotificationFilter _filter = _NotificationFilter.all;

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ref.read(notificationsProvider.notifier).markAllAsRead();
            },
            child: const Text('Mark All Read'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(notificationsProvider.notifier).refresh(),
              child: notificationsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => ListView(
                  children: [
                    const SizedBox(height: Insets.xxl),
                    EmptyStateWidget(
                      icon: Icons.error_outline,
                      title: 'Failed to load notifications',
                      subtitle: e.toString(),
                      actionLabel: 'Retry',
                      onAction: () => ref.invalidate(notificationsProvider),
                    ),
                  ],
                ),
                data: (notifications) {
                  final filtered = _filter == _NotificationFilter.all
                      ? notifications
                      : notifications.where((n) => !n.read).toList();

                  if (filtered.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: Insets.xxl),
                        EmptyStateWidget(
                          icon: Icons.notifications_none,
                          title: _filter == _NotificationFilter.all
                              ? 'No notifications yet'
                              : 'No unread notifications',
                          subtitle: _filter == _NotificationFilter.all
                              ? 'We\'ll notify you when something important happens'
                              : 'You\'re all caught up!',
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Insets.md,
                      vertical: Insets.sm,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final notification = filtered[index];
                      return _NotificationItem(
                        notification: notification,
                        onTap: () {
                          if (!notification.read) {
                            ref
                                .read(notificationsProvider.notifier)
                                .markAsRead(notification.id);
                          }
                        },
                        onDismissed: () {
                          ref
                              .read(notificationsProvider.notifier)
                              .delete(notification.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: Insets.sm,
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.xs),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _filter = _NotificationFilter.all),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Insets.sm),
                  decoration: BoxDecoration(
                    color: _filter == _NotificationFilter.all
                        ? AppColors.darkPrimaryContainer
                        : Colors.transparent,
                    borderRadius: AppRadius.brMd,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'All',
                    style: AppTypography.bodyMd.copyWith(
                      color: _filter == _NotificationFilter.all
                          ? Colors.white
                          : AppColors.darkOnSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    setState(() => _filter = _NotificationFilter.unread),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Insets.sm),
                  decoration: BoxDecoration(
                    color: _filter == _NotificationFilter.unread
                        ? AppColors.darkPrimaryContainer
                        : Colors.transparent,
                    borderRadius: AppRadius.brMd,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Unread',
                    style: AppTypography.bodyMd.copyWith(
                      color: _filter == _NotificationFilter.unread
                          ? Colors.white
                          : AppColors.darkOnSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
    required this.onDismissed,
  });

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.budgetAlert:
        return Icons.warning_amber_rounded;
      case NotificationType.goalReminder:
        return Icons.flag_rounded;
      case NotificationType.monthlySummary:
        return Icons.mail_outline_rounded;
      case NotificationType.insight:
        return Icons.trending_up_rounded;
      case NotificationType.system:
        return Icons.notifications_rounded;
    }
  }

  Color _colorForType(NotificationType type) {
    switch (type) {
      case NotificationType.budgetAlert:
        return AppColors.warning;
      case NotificationType.goalReminder:
        return AppColors.darkPrimary;
      case NotificationType.monthlySummary:
        return AppColors.info;
      case NotificationType.insight:
        return AppColors.success;
      case NotificationType.system:
        return AppColors.darkOnSurfaceVariant;
    }
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Insets.lg),
        margin: const EdgeInsets.only(bottom: Insets.sm),
        decoration: BoxDecoration(
          color: AppColors.darkError.withValues(alpha: 0.3),
          borderRadius: AppRadius.brXl,
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.darkError),
      ),
      onDismissed: (_) => onDismissed(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: Insets.sm),
        child: GlassCard(
          padding: EdgeInsets.zero,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.brXl,
            child: Padding(
              padding: const EdgeInsets.all(Insets.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Insets.sm),
                        decoration: BoxDecoration(
                          color: _colorForType(notification.type)
                              .withValues(alpha: 0.15),
                          borderRadius: AppRadius.brMd,
                        ),
                        child: Icon(
                          _iconForType(notification.type),
                          color: _colorForType(notification.type),
                          size: 22,
                        ),
                      ),
                      if (!notification.read)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.darkPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: AppTypography.bodyMd.copyWith(
                            fontWeight: notification.read
                                ? FontWeight.w400
                                : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: Insets.xs),
                        Text(
                          notification.body,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.darkOnSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Insets.sm),
                  Text(
                    _timeAgo(notification.createdAt),
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.darkOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
