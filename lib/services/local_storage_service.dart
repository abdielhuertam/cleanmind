import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../state/plan_state.dart';
import '../state/protection_state.dart';
import '../state/unlock_request_state.dart';
import '../state/support_request_state.dart';

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

    'xp': plan.xp,
    'level': plan.level,
    'streakDays': plan.streakDays,

  'protectionStatus':
      plan.protection.status.name,

  'protectionMode':
      plan.protection.mode.name,

  'activatedAt':
      plan.protection.activatedAt
          .toIso8601String(),

  'expiresAt':
      plan.protection.expiresAt
          ?.toIso8601String(),

  'unlockRequestStatus':
      plan.unlockRequest.status.name,

  'unlockRequestCreatedAt':
      plan.unlockRequest.createdAt
          ?.toIso8601String(),

  'unlockRequestExpiresAt':
      plan.unlockRequest.expiresAt
          ?.toIso8601String(),

    'supportRequestStatus':
        plan.supportRequest.status.name,

    'supportRequestRequesterName':
        plan.supportRequest.requesterName,

    'supportRequestId':
        plan.supportRequest.requestId,

    'lastProgressAwardAt':
        plan.lastProgressAwardAt
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

final protectionMode =
    ProtectionMode.values.firstWhere(
  (e) =>
      e.name ==
      (map['protectionMode'] ??
          'permanent'),
  orElse: () =>
      ProtectionMode.permanent,
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

final supportRequestStatus =
    SupportRequestStatus.values.firstWhere(
  (e) =>
      e.name ==
      map['supportRequestStatus'],
  orElse: () =>
      SupportRequestStatus.none,
);

return PlanState(
  isPro: map['isPro'] ?? false,

  hasSupport:
      map['hasSupport'] ?? false,

    xp: map['xp'] ?? 0,

    level: map['level'] ?? 1,

    streakDays: map['streakDays'] ?? 0,

  lastProgressAwardAt:
    map['lastProgressAwardAt'] != null
        ? DateTime.parse(
            map['lastProgressAwardAt'],
          )
        : null,

  protection: ProtectionState(
    status: protectionStatus,

    mode: protectionMode,

    activatedAt: DateTime.parse(
      map['activatedAt'],
    ),

    expiresAt:
        map['expiresAt'] != null
            ? DateTime.parse(
                map['expiresAt'],
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

    supportRequest: SupportRequestState(
    status: supportRequestStatus,
    requesterName:
        map['supportRequestRequesterName'],
    requestId:
        map['supportRequestId'],
    ),
);
}
}
