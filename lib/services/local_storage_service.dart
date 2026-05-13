import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../state/plan_state.dart';
import '../state/protection_state.dart';
import '../state/unlock_request_state.dart';

class LocalStorageService {
  static const _planKey = 'plan_state';

  static Future<void> savePlan(
    PlanState plan,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final jsonMap = {
      'isPro': plan.isPro,
      'hasSupport': plan.hasSupport,

      'protectionStatus':
          plan.protection.status.name,

      'activatedAt':
          plan.protection.activatedAt
              .toIso8601String(),

      'deactivationScheduledAt':
          plan.protection
              .deactivationScheduledAt
              ?.toIso8601String(),

      'unlockRequestStatus':
          plan.unlockRequest.status.name,

      'unlockRequestCreatedAt':
          plan.unlockRequest.createdAt
              ?.toIso8601String(),

      'unlockRequestExpiresAt':
          plan.unlockRequest.expiresAt
              ?.toIso8601String(),
    };

    await prefs.setString(
      _planKey,
      jsonEncode(jsonMap),
    );
  }

  static Future<PlanState> loadPlan()
  async {
    final prefs =
        await SharedPreferences.getInstance();

    final raw =
        prefs.getString(_planKey);

    if (raw == null) {
      return PlanState.pro();
    }

    final map = jsonDecode(raw);

    final protectionStatus =
        ProtectionStatus.values.firstWhere(
      (e) =>
          e.name ==
          map['protectionStatus'],
    );

    final unlockRequestStatus =
        UnlockRequestStatus.values
            .firstWhere(
      (e) =>
          e.name ==
          map['unlockRequestStatus'],
      orElse: () =>
          UnlockRequestStatus.none,
    );

    return PlanState(
      isPro: map['isPro'] ?? false,

      hasSupport:
          map['hasSupport'] ?? false,

      protection: ProtectionState(
        status: protectionStatus,

        activatedAt: DateTime.parse(
          map['activatedAt'],
        ),

        deactivationScheduledAt:
            map['deactivationScheduledAt'] !=
                    null
                ? DateTime.parse(
                    map[
                        'deactivationScheduledAt'],
                  )
                : null,
      ),

      unlockRequest: UnlockRequestState(
        status: unlockRequestStatus,

        createdAt:
            map['unlockRequestCreatedAt'] !=
                    null
                ? DateTime.parse(
                    map[
                        'unlockRequestCreatedAt'],
                  )
                : null,

        expiresAt:
            map['unlockRequestExpiresAt'] !=
                    null
                ? DateTime.parse(
                    map[
                        'unlockRequestExpiresAt'],
                  )
                : null,
      ),
    );
  }
}