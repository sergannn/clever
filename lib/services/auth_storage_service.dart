import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Stores auth token and user/cycle settings in SharedPreferences.
class AuthStorageService {
  static const _keyToken = 'auth_token';
  static const _keyUser = 'auth_user';
  static const _keyLastPeriodStartDate = 'last_period_start_date';
  static const _keyCycleLength = 'average_cycle_length';
  static const _keyPeriodLength = 'average_period_length';
  static const _keyTimezone = 'timezone';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  static Future<void> setUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_keyUser);
    if (s == null) return null;
    try {
      return User.fromJson(jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }

  /// Cycle settings (for offline/local calculation and display).
  static Future<void> setCycleSettings({
    required String? lastPeriodStartDate,
    required int? cycleLength,
    required int? periodLength,
    String? timezone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (lastPeriodStartDate != null) {
      await prefs.setString(_keyLastPeriodStartDate, lastPeriodStartDate);
    } else {
      await prefs.remove(_keyLastPeriodStartDate);
    }
    if (cycleLength != null) {
      await prefs.setInt(_keyCycleLength, cycleLength);
    } else {
      await prefs.remove(_keyCycleLength);
    }
    if (periodLength != null) {
      await prefs.setInt(_keyPeriodLength, periodLength);
    } else {
      await prefs.remove(_keyPeriodLength);
    }
    if (timezone != null) {
      await prefs.setString(_keyTimezone, timezone);
    } else {
      await prefs.remove(_keyTimezone);
    }
  }

  static Future<CycleSettings> getCycleSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return CycleSettings(
      lastPeriodStartDate: prefs.getString(_keyLastPeriodStartDate),
      cycleLength: prefs.getInt(_keyCycleLength),
      periodLength: prefs.getInt(_keyPeriodLength),
      timezone: prefs.getString(_keyTimezone) ?? 'UTC',
    );
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    await prefs.remove(_keyLastPeriodStartDate);
    await prefs.remove(_keyCycleLength);
    await prefs.remove(_keyPeriodLength);
    await prefs.remove(_keyTimezone);
  }
}

class CycleSettings {
  final String? lastPeriodStartDate;
  final int? cycleLength;
  final int? periodLength;
  final String timezone;

  CycleSettings({
    this.lastPeriodStartDate,
    this.cycleLength,
    this.periodLength,
    this.timezone = 'UTC',
  });

  bool get hasMinimum =>
      lastPeriodStartDate != null &&
      cycleLength != null &&
      periodLength != null;
}
