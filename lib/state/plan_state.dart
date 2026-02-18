import 'protection_state.dart';

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
      isPro: false,
    );
  }

  PlanState activateProtection() {
    return PlanState(
      protection: protection.activate(),
      isPro: isPro,
    );
  }

  // Mantener compatibilidad con HomeScreen actual
  PlanState requestUnlock() {
    return this;
  }

  PlanState requestDeactivation() {
    return PlanState(
      protection: protection.scheduleDeactivation(),
      isPro: isPro,
    );
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
