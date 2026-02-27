import 'protection_state.dart';

const Duration kFreeDeactivationDuration = Duration(seconds: 10);

class PlanState {
  final ProtectionState protection;
  final bool isPro;

  const PlanState({
    required this.protection,
    required this.isPro,
  });

  factory PlanState.initial() {
    return PlanState(
      protection: const ProtectionState(
        status: ProtectionStatus.inactive,
      ),
      isPro: true,
    );
  }

  PlanState activateProtection() {
    return PlanState(
      protection: protection.activate(),
      isPro: isPro,
    );
  }

  PlanState requestUnlock() {
    return this;
  }

  PlanState requestDeactivation() {
    if (isPro) {
      // Pro: desactivación inmediata
      return PlanState(
        protection: protection.disable(),
        isPro: isPro,
      );
    } else {
      // Free: waiting period obligatorio
      return PlanState(
        protection:
            protection.scheduleDeactivation(kFreeDeactivationDuration),
        isPro: isPro,
      );
    }
  }

  PlanState cancelDeactivation() {
    return PlanState(
      protection: protection.cancelScheduledDeactivation(),
      isPro: isPro,
    );
  }

  PlanState unlockSucceeded() {
    return PlanState(
      protection: protection.disable(),
      isPro: isPro,
    );
  }

  PlanState manualReactivate() {
    return PlanState(
      protection: protection.activate(),
      isPro: isPro,
    );
  }

  PlanState updatePlan(bool newIsPro) {
    return PlanState(
      protection: protection,
      isPro: newIsPro,
    );
  }
}