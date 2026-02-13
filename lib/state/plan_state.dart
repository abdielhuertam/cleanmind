import 'protection_state.dart';

class PlanState {
  final bool isPro;
  final ProtectionState protection;

  const PlanState({
    required this.isPro,
    required this.protection,
  });

  factory PlanState.initial({required bool isPro}) {
    return PlanState(
      isPro: isPro,
      protection: const ProtectionState(
        status: ProtectionStatus.inactive,
      ),
    );
  }

  PlanState activateProtection() {
    return PlanState(
      isPro: isPro,
      protection: protection.activate(),
    );
  }

  PlanState requestUnlock() {
    return PlanState(
      isPro: isPro,
      protection: protection.requestDeactivation(),
    );
  }

  PlanState unlockSucceeded() {
    return PlanState(
      isPro: isPro,
      protection: protection.disable(),
    );
  }

  PlanState manualReactivate() {
    return PlanState(
      isPro: isPro,
      protection: protection.manualReactivate(),
    );
  }
}
