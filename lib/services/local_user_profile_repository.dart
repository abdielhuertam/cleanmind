import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';
import 'user_profile_repository.dart';

class LocalUserProfileRepository
    implements UserProfileRepository {
  static const String _profileKey =
      'user_profile';

  @override
  Future<UserProfile?> getProfile() async {
    final prefs =
        await SharedPreferences.getInstance();

    final raw =
        prefs.getString(_profileKey);

    if (raw == null) {
      return null;
    }

    final json =
        jsonDecode(raw)
            as Map<String, dynamic>;

    return UserProfile.fromJson(
      json,
    );
  }

  @override
  Future<void> saveProfile(
    UserProfile profile,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _profileKey,
      jsonEncode(
        profile.toJson(),
      ),
    );
  }

  @override
  Future<void> updateUsername(
    String username,
  ) async {
    final profile =
        await getProfile();

    if (profile == null) {
      return;
    }

    await saveProfile(
      profile.copyWith(
        username: username,
      ),
    );
  }

  @override
  Future<void> deleteProfile() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      _profileKey,
    );
  }
}