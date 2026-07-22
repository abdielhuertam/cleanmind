import 'protection_state.dart';
import 'unlock_request_state.dart';
import 'support_request_state.dart';

const Duration kPushRequestDuration =
    Duration(minutes: 5);

class PlanState {
  final bool isPro;
  final bool hasSupport;

  final ProtectionState protection;

  final UnlockRequestState unlockRequest;

  final SupportRequestState supportRequest;

  final int xp;
  final int level;
  final int streakDays;
  final DateTime? lastProgressAwardAt;

  final bool milestoneCelebrationsEnabled;
  final bool levelUpNotificationsEnabled;
  final bool recurringProgressReminderEnabled;
  final int recurringReminderDays;

  const PlanState({
    required this.isPro,
    required this.hasSupport,
    required this.protection,
    required this.unlockRequest,
    required this.supportRequest,
    required this.xp,
    required this.level,
    required this.streakDays,
    required this.lastProgressAwardAt,

    required this.milestoneCelebrationsEnabled,
    required this.levelUpNotificationsEnabled,
    required this.recurringProgressReminderEnabled,
    required this.recurringReminderDays,
  });

  factory PlanState.free() {
    return PlanState(
      isPro: false,
      hasSupport: false,
      protection: ProtectionState.active(),
      unlockRequest:
          UnlockRequestState.none(),
      supportRequest:
          SupportRequestState.none(),
      xp: 0,
      level: 1,
      streakDays: 0,
      lastProgressAwardAt: null,
      milestoneCelebrationsEnabled: true,
      levelUpNotificationsEnabled: true,
      recurringProgressReminderEnabled: false,
      recurringReminderDays: 7,
    );
  }

  factory PlanState.pro() {
    return PlanState(
      isPro: true,
      hasSupport: false,
      protection: ProtectionState.active(),
      unlockRequest:
          UnlockRequestState.none(),
      supportRequest:
          SupportRequestState.none(),
      
      xp: 0,
      level: 1,
      streakDays: 0,
      lastProgressAwardAt: null,
      milestoneCelebrationsEnabled: true,
      levelUpNotificationsEnabled: true,
      recurringProgressReminderEnabled: false,
      recurringReminderDays: 7,
    );
  }

  PlanState copyWith({
    bool? isPro,
    bool? hasSupport,
    ProtectionState? protection,
    UnlockRequestState? unlockRequest,
    int? xp,
    int? level,
    int? streakDays,
    DateTime? lastProgressAwardAt,
    SupportRequestState? supportRequest,
    bool? milestoneCelebrationsEnabled,
    bool? levelUpNotificationsEnabled,
    bool? recurringProgressReminderEnabled,
    int? recurringReminderDays,
  }) {
    return PlanState(
      isPro: isPro ?? this.isPro,
      hasSupport:
          hasSupport ?? this.hasSupport,
      protection:
          protection ?? this.protection,
      unlockRequest:
          unlockRequest ?? this.unlockRequest,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streakDays:
          streakDays ?? this.streakDays,
      lastProgressAwardAt:
          lastProgressAwardAt ??
          this.lastProgressAwardAt, 
      supportRequest:
          supportRequest ?? this.supportRequest,   
      milestoneCelebrationsEnabled:
          milestoneCelebrationsEnabled ??
          this.milestoneCelebrationsEnabled,

      levelUpNotificationsEnabled:
          levelUpNotificationsEnabled ??
          this.levelUpNotificationsEnabled,

      recurringProgressReminderEnabled:
          recurringProgressReminderEnabled ??
          this.recurringProgressReminderEnabled,

      recurringReminderDays:
          recurringReminderDays ??
          this.recurringReminderDays,
    );
  }

  PlanState refreshLifecycle() {
    PlanState updated = this;

    // Partial Protection Expiration

    if (updated.protection.status ==
            ProtectionStatus.active &&
        updated.protection.mode ==
            ProtectionMode.partial &&
        updated.protection
            .isPartialExpired()) {

      updated = updated.copyWith(
        protection:
            updated.protection
                .disableProtection(),
      );
    }

    // Push Request Expiration

    if (updated.unlockRequest.isPending &&
        updated.unlockRequest
            .isExpired()) {
      updated =
          updated.expirePushRequest();
    }

    return updated.refreshProgress();
  }

  PlanState refreshProgress() {

    if (protection.status !=
        ProtectionStatus.active) {
      return this;
    }

    final now = DateTime.now();

    if (lastProgressAwardAt == null) {

      return copyWith(
        lastProgressAwardAt: now,
      );
    }

    if (protection.mode ==
        ProtectionMode.partial) {

      final elapsedHours =
          now
              .difference(
                lastProgressAwardAt!,
              )
              .inHours;

      if (elapsedHours <= 0) {
        return this;
      }

      final earnedXp =
          elapsedHours * 3;

      final newXp =
          xp + earnedXp;

      return copyWith(
        xp: newXp,

        level:
            1 + (newXp ~/ 1000),

        lastProgressAwardAt:
            lastProgressAwardAt!.add(
          Duration(
            hours: elapsedHours,
          ),
        ),
      );
    }

    if (protection.mode ==
      ProtectionMode.permanent) {

    final elapsedHours =
        now
            .difference(
              lastProgressAwardAt!,
            )
            .inHours;

    if (elapsedHours <= 0) {
      return this;
    }

    final earnedXp =
        elapsedHours * 4;

    final newXp =
        xp + earnedXp;

    return copyWith(
      xp: newXp,

      level:
          1 + (newXp ~/ 1000),

      lastProgressAwardAt:
          lastProgressAwardAt!.add(
        Duration(
          hours: elapsedHours,
        ),
      ),
    );
  }

    return this;
  }

  PlanState unlockSucceeded() {
    return copyWith(
      protection:
          protection.disableProtection(),
      unlockRequest:
          UnlockRequestState.none(),
    );
  }

  PlanState manualReactivate() {
    return copyWith(
      protection:
          ProtectionState.active(),
      unlockRequest:
          UnlockRequestState.none(),
    );
  }

  PlanState activatePartialProtection(
  DateTime expiresAt,
) {
  return copyWith(
    protection:
        ProtectionState.active(
      mode:
          ProtectionMode.partial,
      expiresAt: expiresAt,
    ),
    unlockRequest:
        UnlockRequestState.none(),
  );
}

PlanState startPushRequest({
  required String requesterName,
}) {
  return copyWith(
    unlockRequest:
        unlockRequest.createPending(
      duration: kPushRequestDuration,
      requesterName: requesterName,
    ),
  );
}

  PlanState cancelPushRequest() {
    return copyWith(
      unlockRequest:
          unlockRequest.cancel(),
    );
  }

  PlanState approvePushRequest() {
    return copyWith(
      protection:
          protection.disableProtection(),
      unlockRequest:
          UnlockRequestState.none(),
    );
  }
  
  PlanState rejectPushRequest() {
    return copyWith(
      unlockRequest:
          UnlockRequestState.none(),
    );
  }

  PlanState expirePushRequest() {
    return copyWith(
      unlockRequest:
          unlockRequest.expire(),
    );
  }

PlanState startSupportRemovalRequest({
  required String requesterName,
}) {
  return copyWith(
    supportRequest:
        supportRequest.createPending(
      requesterName: requesterName,
    ),
  );
}

PlanState approveSupportRemovalRequest() {
  return copyWith(
    supportRequest:
        supportRequest.approve(),
  );
}

PlanState rejectSupportRemovalRequest() {
  return copyWith(
    supportRequest:
        supportRequest.reject(),
  );
}

PlanState clearSupportRequest() {
  return copyWith(
    supportRequest:
        supportRequest.clear(),
  );
}

}