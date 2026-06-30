import '../../../../core/services/api_service.dart';
import '../../../../core/services/hive_service.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final ApiService _api;
  final HiveService _hive;

  SettingsRepositoryImpl(this._api, this._hive);

  @override
  Future<SettingsEntity> getSettings() async {
    try {
      final response = await _api.get('/settings');
      final data = response.data['data'] as Map<String, dynamic>;
      final model = SettingsModel.fromJson(data);
      await HiveService.saveSetting('settings', model.toJson());
      return model.toEntity();
    } catch (_) {
      final cached = HiveService.getSetting('settings');
      if (cached != null) {
        return SettingsModel.fromJson(cached as Map<String, dynamic>)
            .toEntity();
      }
      return const SettingsEntity();
    }
  }

  @override
  Future<SettingsEntity> updateSettings(SettingsEntity settings) async {
    final model = SettingsModel.fromEntity(settings);
    final response = await _api.put('/settings', data: model.toJson());
    final data = response.data['data'] as Map<String, dynamic>;
    final updatedModel = SettingsModel.fromJson(data);
    await HiveService.saveSetting('settings', updatedModel.toJson());
    return updatedModel.toEntity();
  }
}
