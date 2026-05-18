import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

  static const String
  blockedSitesKey =
      'blocked_sites';

  static const String
  supportPhoneKey =
      'support_phone';

  static const String
  protectionEnabledKey =
      'protection_enabled';

  static const String
  waitingPeriodKey =
      'waiting_period';

  static const String
  customUnlockDateKey =
      'custom_unlock_date';

  static const String
  streakDaysKey =
      'streak_days';

  static Future<void>
  saveBlockedSites(
    List<String> sites,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      blockedSitesKey,
      jsonEncode(sites),
    );
  }

  static Future<List<String>>
  loadBlockedSites() async {

    final prefs =
        await SharedPreferences.getInstance();

    final raw =
        prefs.getString(
      blockedSitesKey,
    );

    if (raw == null) {
      return [];
    }

    final decoded =
        jsonDecode(raw);

    return List<String>.from(
      decoded,
    );
  }

  static Future<void>
  saveSupportPhone(
    String phone,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      supportPhoneKey,
      phone,
    );
  }

  static Future<String?>
  loadSupportPhone() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      supportPhoneKey,
    );
  }

  static Future<void>
  saveProtectionEnabled(
    bool enabled,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      protectionEnabledKey,
      enabled,
    );
  }

  static Future<bool>
  loadProtectionEnabled()
  async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(
          protectionEnabledKey,
        ) ??
        false;
  }

  static Future<void>
  saveWaitingPeriod(
    String value,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      waitingPeriodKey,
      value,
    );
  }

  static Future<String?>
  loadWaitingPeriod() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      waitingPeriodKey,
    );
  }

  static Future<void>
  saveCustomUnlockDate(
    DateTime date,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      customUnlockDateKey,
      date.toIso8601String(),
    );
  }

  static Future<DateTime?>
  loadCustomUnlockDate()
  async {

    final prefs =
        await SharedPreferences.getInstance();

    final raw =
        prefs.getString(
      customUnlockDateKey,
    );

    if (raw == null) {
      return null;
    }

    return DateTime.parse(
      raw,
    );
  }

  static Future<void>
  saveStreakDays(
    int days,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setInt(
      streakDaysKey,
      days,
    );
  }

  static Future<int>
  loadStreakDays() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt(
          streakDaysKey,
        ) ??
        0;
  }
}