import 'protection_state.dart';
import 'unlock_request_state.dart';

const Duration kPushRequestDuration =
    Duration(minutes: 5);

class PlanState {
  final bool isPro;
  final bool hasSupport;

  final ProtectionState protection;

  final UnlockRequestState unlockRequest;

  final int xp;
  final int level;
  final int streakDays;
  final DateTime? lastProgressAwardAt;

  const PlanState({
    required this.isPro,
    required this.hasSupport,
    required this.protection,
    required this.unlockRequest,
    required this.xp,
    required this.level,
    required this.streakDays,
    required this.lastProgressAwardAt,
  });

  factory PlanState.free() {
    return PlanState(
      isPro: false,
      hasSupport: false,
      protection: ProtectionState.active(),
      unlockRequest:
          UnlockRequestState.none(),
      xp: 0,
      level: 1,
      streakDays: 0,
      lastProgressAwardAt: null,
    );
  }

  factory PlanState.pro() {
    return PlanState(
      isPro: true,
      hasSupport: false,
      protection: ProtectionState.active(),
      unlockRequest:
          UnlockRequestState.none(),
      xp: 0,
      level: 1,
      streakDays: 0,
      lastProgressAwardAt: null,
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

  PlanState startPushRequest() {
    return copyWith(
      unlockRequest:
          unlockRequest.createPending(
        duration:
            kPushRequestDuration,
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
}