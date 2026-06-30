import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(apiServiceProvider));
});

final unreadCountProvider = FutureProvider<int>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getUnreadCount();
});

final notificationsProvider =
    AsyncNotifierProvider<NotificationListNotifier, List<NotificationEntity>>(
  NotificationListNotifier.new,
);

class NotificationListNotifier
    extends AsyncNotifier<List<NotificationEntity>> {
  @override
  Future<List<NotificationEntity>> build() async {
    final repo = ref.read(notificationRepositoryProvider);
    return repo.getNotifications();
  }

  Future<void> markAsRead(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAsRead(id);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncValue.data(
        current.map((n) => n.id == id ? n.copyWith(read: true) : n).toList(),
      );
    }
    ref.invalidate(unreadCountProvider);
  }

  Future<void> markAllAsRead() async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAllAsRead();
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncValue.data(
        current.map((n) => n.copyWith(read: true)).toList(),
      );
    }
    ref.invalidate(unreadCountProvider);
  }

  Future<void> delete(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.delete(id);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncValue.data(current.where((n) => n.id != id).toList());
    }
    ref.invalidate(unreadCountProvider);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(notificationRepositoryProvider);
      return repo.getNotifications();
    });
  }
}
