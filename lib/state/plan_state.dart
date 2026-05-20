import 'protection_state.dart';
import 'unlock_request_state.dart';

const Duration kFreeWaitingDuration =
    Duration(hours: 8);

const Duration kProWaitingDuration =
    Duration(hours: 1);

const Duration kPushRequestDuration =
    Duration(minutes: 5);

class PlanState {
  final bool isPro;
  final bool hasSupport;

  final ProtectionState protection;

  final UnlockRequestState unlockRequest;

  const PlanState({
    required this.isPro,
    required this.hasSupport,
    required this.protection,
    required this.unlockRequest,
  });

  factory PlanState.free() {
    return PlanState(
      isPro: false,
      hasSupport: false,
      protection: ProtectionState.active(),
      unlockRequest:
          UnlockRequestState.none(),
    );
  }

  factory PlanState.pro() {
    return PlanState(
      isPro: true,
      hasSupport: false,
      protection: ProtectionState.active(),
      unlockRequest:
          UnlockRequestState.none(),
    );
  }

  PlanState copyWith({
    bool? isPro,
    bool? hasSupport,
    ProtectionState? protection,
    UnlockRequestState? unlockRequest,
  }) {
    return PlanState(
      isPro: isPro ?? this.isPro,
      hasSupport:
          hasSupport ?? this.hasSupport,
      protection:
          protection ?? this.protection,
      unlockRequest:
          unlockRequest ?? this.unlockRequest,
    );
  }

  PlanState refreshLifecycle() {
    PlanState updated = this;

    // Waiting Period Expiration

    if (updated.protection.status ==
            ProtectionStatus
                .waitingPeriod &&
        updated.protection
            .isDeactivationExpired()) {
      updated =
          updated.unlockSucceeded();
    }

    // Push Request Expiration

    if (updated.unlockRequest.isPending &&
        updated.unlockRequest
            .isExpired()) {
      updated =
          updated.expirePushRequest();
    }

    return updated;
  }

  PlanState requestDeactivation() {
    return copyWith(
      protection:
          protection.scheduleWaitingPeriod(
        isPro
            ? kProWaitingDuration
            : kFreeWaitingDuration,
      ),
    );
  }

  PlanState cancelDeactivation() {
    return copyWith(
      protection:
          protection.cancelDeactivation(),
    );
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
          unlockRequest.approve(),
    );
  }

  PlanState rejectPushRequest() {
    return copyWith(
      unlockRequest:
          unlockRequest.reject(),
    );
  }

  PlanState expirePushRequest() {
    return copyWith(
      unlockRequest:
          unlockRequest.expire(),
    );
  }
}