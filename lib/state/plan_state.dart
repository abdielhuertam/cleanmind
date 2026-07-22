import 'protection_state.dart';
import 'unlock_request_state.dart';
import 'support_request_state.dart';
import 'celebration_state.dart';

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
  final DateTime? lastStreakAwardAt;
  final CelebrationState celebration;
  final bool partialProtectionNotificationsEnabled;
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
    required this.lastStreakAwardAt,
    required this.celebration,
    required this.partialProtectionNotificationsEnabled,
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
      lastStreakAwardAt: null,
      celebration: CelebrationState.none(),
      partialProtectionNotificationsEnabled: true,
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
      lastStreakAwardAt: null,
      celebration: CelebrationState.none(),
      partialProtectionNotificationsEnabled: true,
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
    DateTime? lastStreakAwardAt,
    CelebrationState? celebration,
    SupportRequestState? supportRequest,
    bool? partialProtectionNotificationsEnabled,
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
      lastStreakAwardAt:
          lastStreakAwardAt ??
          this.lastStreakAwardAt,
      celebration:
          celebration ??
          this.celebration,
      supportRequest:
          supportRequest ?? this.supportRequest,   

      partialProtectionNotificationsEnabled:
          partialProtectionNotificationsEnabled ??
          this.partialProtectionNotificationsEnabled,

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

    if (lastProgressAwardAt == null ||
        lastStreakAwardAt == null) {

      final previous = protection.mode == ProtectionMode.permanent
          ? now.subtract(const Duration(hours: 1))
          : now.subtract(const Duration(hours: 1));

      return copyWith(
        lastProgressAwardAt: previous,
        lastStreakAwardAt: previous,
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

      final newLevel =
          1 + (newXp ~/ 1000);

      CelebrationState celebration =
          this.celebration;

      if (newLevel > level) {
        celebration = CelebrationState(
          type: CelebrationType.levelUp,
          title: 'Level Up!',
          message:
              'Congratulations! You reached Level $newLevel.',
          level: newLevel,
        );
      }

      return copyWith(
        xp: newXp,

        level: newLevel,

        celebration: celebration,

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

    final elapsedDays =
        now
            .difference(
              lastStreakAwardAt!,
            )
            .inDays;

    final earnedXp =
        elapsedHours * 4;

    final newXp =
        xp + earnedXp;

    final newLevel =
        1 + (newXp ~/ 1000);

    final newStreak =
        streakDays + elapsedDays;

    CelebrationState celebration =
        this.celebration;

    if (newLevel > level) {
      celebration = CelebrationState(
        type: CelebrationType.levelUp,
        title: 'Level Up!',
        message:
            'Congratulations! You reached Level $newLevel.',
        level: newLevel,
      );
    } else {
      switch (newStreak) {
        case 7:
        case 30:
        case 90:
        case 180:
        case 365:
          celebration = CelebrationState(
            type: CelebrationType.streak,
            title: '$newStreak Day Streak!',
            message:
                'Congratulations! You reached a $newStreak-day streak.',
            streakDays: newStreak,
          );
          break;
      }
    }

    return copyWith(
      xp: newXp,
      level: newLevel,
      celebration: celebration,
      streakDays: newStreak,

      lastProgressAwardAt:
          lastProgressAwardAt!.add(
        Duration(
          hours: elapsedHours,
        ),
      ),

      lastStreakAwardAt:
          elapsedDays > 0
              ? lastStreakAwardAt!.add(
                  Duration(
                    days: elapsedDays,
                  ),
                )
              : lastStreakAwardAt,
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