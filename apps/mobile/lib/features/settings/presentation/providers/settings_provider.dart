import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/services/hive_service.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    ref.watch(apiServiceProvider),
    ref.watch(hiveServiceProvider),
  );
});

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, SettingsEntity>(
  SettingsNotifier.new,
);

class SettingsNotifier extends AsyncNotifier<SettingsEntity> {
  @override
  Future<SettingsEntity> build() async {
    final repo = ref.read(settingsRepositoryProvider);
    return repo.getSettings();
  }

  Future<void> updateSettings(SettingsEntity settings) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(settingsRepositoryProvider);
      return repo.updateSettings(settings);
    });
  }

  Future<void> updateTheme(String theme) async {
    final current = state.valueOrNull;
    if (current != null) {
      await updateSettings(current.copyWith(theme: theme));
    }
  }

  Future<void> updateLanguage(String language) async {
    final current = state.valueOrNull;
    if (current != null) {
      await updateSettings(current.copyWith(language: language));
    }
  }

  Future<void> updateCurrency(String currency) async {
    final current = state.valueOrNull;
    if (current != null) {
      await updateSettings(current.copyWith(currency: currency));
    }
  }

  Future<void> updateExportFormat(String format) async {
    final current = state.valueOrNull;
    if (current != null) {
      await updateSettings(current.copyWith(exportFormat: format));
    }
  }

  Future<void> toggleNotification(String key, bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final n = current.notifications;
    final updated = current.copyWith(
      notifications: NotificationsConfig(
        budgetAlerts: key == 'budgetAlerts' ? value : n.budgetAlerts,
        goalReminders: key == 'goalReminders' ? value : n.goalReminders,
        monthlySummary: key == 'monthlySummary' ? value : n.monthlySummary,
        insights: key == 'insights' ? value : n.insights,
      ),
    );
    await updateSettings(updated);
  }

  Future<void> togglePrivacy(String key, bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final p = current.privacy;
    final updated = current.copyWith(
      privacy: PrivacyConfig(
        showBalance: key == 'showBalance' ? value : p.showBalance,
        showTransactions:
            key == 'showTransactions' ? value : p.showTransactions,
      ),
    );
    await updateSettings(updated);
  }

  Future<void> clearCache() async {
    await HiveService.clearQueue();
  }
}
