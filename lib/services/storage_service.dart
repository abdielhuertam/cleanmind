import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

  static const String
  blockedSitesKey =
      'blocked_sites';

  static const String
  blockedAppsKey =
      'blocked_apps';

  static const String
  supportNameKey =
      'support_name';

  static const String
  supportPhoneKey =
      'support_phone';
    
  static const String
  supportTypeKey =
      'support_type';

  static const String
  supportStatusKey =
      'support_status';


  static const String
  supportRemovalRequestIdKey =
      'support_removal_request_id';

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
  saveBlockedApps(
    List<String> apps,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      blockedAppsKey,
      jsonEncode(apps),
    );
  }

  static Future<List<String>>
  loadBlockedApps() async {

    final prefs =
        await SharedPreferences.getInstance();

    final raw =
        prefs.getString(
      blockedAppsKey,
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
  saveSupportName(
    String name,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      supportNameKey,
      name,
    );
  }

  static Future<String?>
  loadSupportName() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      supportNameKey,
    );
  }

  static Future<void> saveSupportType(
    String type,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      supportTypeKey,
      type,
    );
  }

  static Future<String?>
  loadSupportType() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      supportTypeKey,
    );
  }

static Future<void> saveSupportStatus(
  String status,
) async {
  final prefs =
      await SharedPreferences.getInstance();

  await prefs.setString(
    supportStatusKey,
    status,
  );
}

static Future<String> loadSupportStatus() async {
  final prefs =
      await SharedPreferences.getInstance();

  return prefs.getString(
        supportStatusKey,
      ) ??
      'active';
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

  static Future<void> saveSupportRemovalRequestId(
    String requestId,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      supportRemovalRequestIdKey,
      requestId,
    );
  }

  static Future<String?>
  loadSupportRemovalRequestId() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      supportRemovalRequestIdKey,
    );
  }

  static Future<void>
  clearSupportRemovalRequestId() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      supportRemovalRequestIdKey,
    );
  }

  static Future<void>
  clearSupport() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      supportNameKey,
    );

    await prefs.remove(
      supportPhoneKey,
    );

    await prefs.remove(
      supportTypeKey,
    );

    await prefs.remove(
      supportStatusKey,
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