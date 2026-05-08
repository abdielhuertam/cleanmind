import 'protection_state.dart';

const Duration kFreeDeactivationDuration = Duration(hours: 8);

class PlanState {
  final ProtectionState protection;
  final bool isPro;
  final bool hasSupport;

  const PlanState({
    required this.protection,
    required this.isPro,
    required this.hasSupport,
  });

  factory PlanState.initial() {
    return PlanState(
      protection: const ProtectionState(
        status: ProtectionStatus.inactive,
      ),
      isPro: true,
      hasSupport: false,
    );
  }

  PlanState activateProtection() {
    return PlanState(
      protection: protection.activate(),
      isPro: isPro,
      hasSupport: hasSupport,
    );
  }

  PlanState requestUnlock() {
    return this;
  }

  PlanState requestDeactivation() {
    // FREE
    if (!isPro) {
      return PlanState(
        protection: protection.scheduleWaitingPeriod(
          kFreeDeactivationDuration,
        ),
        isPro: isPro,
        hasSupport: hasSupport,
      );
    }

    // PRO SIN SOPORTE
    if (isPro && !hasSupport) {
      return PlanState(
        protection: protection.scheduleWaitingPeriod(
          const Duration(hours: 1),
        ),
        isPro: isPro,
        hasSupport: hasSupport,
      );
    }

    // PRO CON SOPORTE
    return PlanState(
      protection: protection.requestApproval(),
      isPro: isPro,
      hasSupport: hasSupport,
    );
  }

  PlanState cancelDeactivation() {
    return PlanState(
      protection: protection.cancelScheduledDeactivation(),
      isPro: isPro,
      hasSupport: hasSupport,
    );
  }

  PlanState unlockSucceeded() {
    return PlanState(
      protection: protection.disable(),
      isPro: isPro,
      hasSupport: hasSupport,
    );
  }

  PlanState manualReactivate() {
    return PlanState(
      protection: protection.activate(),
      isPro: isPro,
      hasSupport: hasSupport,
    );
  }

  PlanState updatePlan(bool newIsPro) {
    return PlanState(
      protection: protection,
      isPro: newIsPro,
      hasSupport: hasSupport,
    );
  }

  PlanState updateSupport(bool newHasSupport) {
    return PlanState(
      protection: protection,
      isPro: isPro,
      hasSupport: newHasSupport,
    );
  }
}