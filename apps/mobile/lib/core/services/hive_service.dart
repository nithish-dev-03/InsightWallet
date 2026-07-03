import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _transactionsBox = 'transactions_cache';
  static const String _settingsBox = 'app_settings';
  static const String _offlineQueueBox = 'offline_queue';
  static const String _categoriesBox = 'categories_cache';

  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox(_transactionsBox);
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_offlineQueueBox);
    await Hive.openBox(_categoriesBox);
  }

  // ── Transactions Cache ──────────────────────
  static Box _transactions() => Hive.box(_transactionsBox);

  static Future<void> cacheTransactions(
      List<Map<String, dynamic>> transactions) async {
    final box = _transactions();
    await box.clear();
    for (int i = 0; i < transactions.length; i++) {
      await box.put(i.toString(), transactions[i]);
    }
  }

  static List<dynamic> getCachedTransactions() {
    return _transactions().values.toList();
  }

  // ── Settings ────────────────────────────────
  static Box _settings() => Hive.box(_settingsBox);

  static Future<void> saveSetting(String key, dynamic value) async {
    await _settings().put(key, value);
  }

  static dynamic getSetting(String key) {
    return _settings().get(key);
  }

  // ── Offline Queue ───────────────────────────
  static Box _offlineQueue() => Hive.box(_offlineQueueBox);

  static Future<void> addToQueue(Map<String, dynamic> operation) async {
    final queue = _offlineQueue();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await queue.put(id, operation);
  }

  static List<Map<String, dynamic>> getQueue() {
    final queue = _offlineQueue();
    return queue.values.cast<Map<String, dynamic>>().toList();
  }

  static Future<void> removeFromQueue(String id) async {
    await _offlineQueue().delete(id);
  }

  static Future<void> clearQueue() async {
    await _offlineQueue().clear();
  }

  static int get queueLength => _offlineQueue().length;

  // ── Categories Cache ────────────────────────
  static Box _categories() => Hive.box(_categoriesBox);

  static Future<void> cacheCategories(
      List<Map<String, dynamic>> categories) async {
    final box = _categories();
    await box.clear();
    for (int i = 0; i < categories.length; i++) {
      await box.put(i.toString(), categories[i]);
    }
  }

  static List<dynamic> getCachedCategories() {
    return _categories().values.toList();
  }
}
