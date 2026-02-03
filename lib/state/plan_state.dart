// lib/state/plan_state.dart

import 'dart:async';
import 'package:flutter/foundation.dart';

/// --------------------------------------------
/// CleanMind — Plan & Protection State
/// --------------------------------------------
/// Source of truth for protection, unlock,
/// and total deactivation logic.
/// --------------------------------------------

enum UserPlan {
  free,
  premium,
}

enum ProtectionLifecycle {
  /// Protection has never been activated
  inactive,

  /// Protection is active and enforced
  active,

  /// Temporary unlock (auto-restores)
  temporarilyUnlocked,

  /// User requested total deactivation
  /// but friction is still in progress
  deactivationPending,

  /// Protection fully disabled
  protectionDisabled,
}

enum DeactivationMethod {
  timedMessage,
  accountabilityContact,
  waitingPeriod,
}

class PlanState extends ChangeNotifier {
  // ----------------------------
  // Core State
  // ----------------------------

  UserPlan plan;
  ProtectionLifecycle lifecycle;
  bool protectionEverActivated;

  // ----------------------------
  // Temporary Unlock
  // ----------------------------

  DateTime? unlockEndsAt;

  // ----------------------------
  // Total Deactivation
  // ----------------------------

  DeactivationMethod? deactivationMethod;
  DateTime? deactivationAvailableAt;

  // ----------------------------
  // Constructor
  // ----------------------------

  PlanState({
    required this.plan,
    required this.lifecycle,
    required this.protectionEverActivated,
    this.unlockEndsAt,
    this.deactivationMethod,
    this.deactivationAvailableAt,
  });

  // ----------------------------
  // Initial State
  // ----------------------------

  factory PlanState.initial() {
    return PlanState(
      plan: UserPlan.free,
      lifecycle: ProtectionLifecycle.inactive,
      protectionEverActivated: false,
    );
  }

  // ----------------------------
  // Derived Helpers
  // ----------------------------

  bool get isProtectionActive =>
      lifecycle == ProtectionLifecycle.active;

  bool get isProtectionDisabled =>
      lifecycle == ProtectionLifecycle.protectionDisabled;

  bool get isDeactivationPending =>
      lifecycle == ProtectionLifecycle.deactivationPending;

  bool get canRequestTemporaryUnlock =>
      lifecycle == ProtectionLifecycle.active;

  // ----------------------------
  // Protection Activation
  // ----------------------------

  void activateProtection() {
    protectionEverActivated = true;
    lifecycle = ProtectionLifecycle.active;
    notifyListeners();
  }

  // ----------------------------
  // Temporary Unlock
  // ----------------------------

  void startTemporaryUnlock(Duration duration) {
    if (!canRequestTemporaryUnlock) return;

    unlockEndsAt = DateTime.now().add(duration);
    lifecycle = ProtectionLifecycle.temporarilyUnlocked;
    notifyListeners();
  }

  void restoreProtectionFromUnlock() {
    if (!protectionEverActivated) return;

    unlockEndsAt = null;
    lifecycle = ProtectionLifecycle.active;
    notifyListeners();
  }

  // ----------------------------
  // Total Deactivation — A1
  // ----------------------------

  /// User starts total deactivation
void requestTotalDeactivation({
  required DeactivationMethod method,
}) {
  deactivationMethod = method;
  lifecycle = ProtectionLifecycle.deactivationPending;

  if (method == DeactivationMethod.waitingPeriod) {
    // ⏱️ SIMULACIÓN PARA MVP (5 segundos)
    // En producción:
    // Free  -> 8 horas
    // Pro   -> tiempo configurable
    final waitDuration =
        plan == UserPlan.free ? const Duration(seconds: 5) : const Duration(seconds: 3);

    deactivationAvailableAt =
        DateTime.now().add(waitDuration);

    Timer(waitDuration, () {
      completeTotalDeactivation();
    });
  }

  notifyListeners();
}

  /// Called when friction is completed
  void completeTotalDeactivation() {
    lifecycle = ProtectionLifecycle.protectionDisabled;
    unlockEndsAt = null;
    notifyListeners();
  }

  /// Manual reactivation only
  void reactivateProtection() {
    lifecycle = ProtectionLifecycle.active;
    deactivationMethod = null;
    deactivationAvailableAt = null;
    notifyListeners();
  }
}
