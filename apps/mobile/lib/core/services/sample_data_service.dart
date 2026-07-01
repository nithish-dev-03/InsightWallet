import 'dart:convert';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

/// Service to load sample JSON data from assets when [isLoadSampleData] is enabled.
class SampleDataService {
  SampleDataService._();

  /// Loads JSON from assets/sample_data/ based on the file name.
  /// Returns the parsed JSON map.
  static Future<Map<String, dynamic>> load(String fileName) async {
    final path = 'assets/sample_data/$fileName';
    final raw = await rootBundle.loadString(path);
    return json.decode(raw) as Map<String, dynamic>;
  }

  /// Helper to get profile data.
  static Future<Map<String, dynamic>> getProfileData() =>
      load('profileData.json');

  /// Helper to get dashboard data.
  static Future<Map<String, dynamic>> getDashboardData() =>
      load('dashboardData.json');

  /// Helper to get transactions data.
  static Future<Map<String, dynamic>> getTransactionsData() =>
      load('transactionsData.json');

  /// Helper to get reports data.
  static Future<Map<String, dynamic>> getReportsData() =>
      load('reportsData.json');

  /// Helper to get insights data.
  static Future<Map<String, dynamic>> getInsightsData() =>
      load('insightsData.json');
}