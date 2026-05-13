import 'protection_state.dart';
import 'unlock_request_state.dart';

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

  PlanState requestDeactivation() {
    if (isPro) {
      return copyWith(
        protection:
            protection.scheduleWaitingPeriod(
          const Duration(hours: 1),
        ),
      );
    }

    return copyWith(
      protection:
          protection.scheduleWaitingPeriod(
        const Duration(hours: 8),
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
        duration: const Duration(
          minutes: 5,
        ),
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