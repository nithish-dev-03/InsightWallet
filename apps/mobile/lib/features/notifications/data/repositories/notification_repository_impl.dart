import '../../../../core/services/api_service.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiService _api;

  NotificationRepositoryImpl(this._api);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final response = await _api.get('/notifications');
    final list = response.data['data'] as List<dynamic>;
    return list
        .map((e) =>
            NotificationModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await _api.patch('/notifications/$id/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await _api.patch('/notifications/read-all');
  }

  @override
  Future<void> delete(String id) async {
    await _api.delete('/notifications/$id');
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _api.get('/notifications/unread-count');
    return response.data['data']['count'] as int;
  }
}
