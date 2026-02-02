// lib/state/plan_state.dart

import 'dart:async';
import 'package:flutter/foundation.dart';

/// ------------------------------------------------------------
/// CleanMind — Plan & Protection State
/// ------------------------------------------------------------
/// Canonical source of truth for product protection state.
/// Product authority: Product_Flow.md
/// ------------------------------------------------------------

enum UserPlan {
  free,
  pro,
}

enum ProtectionLifecycle {
  /// App installed, but protection NOT activated yet
  inactive,

  /// Protection active and enforced
  active,

  /// Protection temporarily disabled by intentional unlock
  temporarilyUnlocked,
}

class PlanState extends ChangeNotifier {
  /// -------------------------------
  /// Core Product State
  /// -------------------------------

  bool protectionEverActivated;
  ProtectionLifecycle lifecycle;
  UserPlan plan;

  /// -------------------------------
  /// Temporary Unlock State
  /// -------------------------------

  DateTime? unlockEndsAt;
  Timer? unlockTimer;

  PlanState({
    required this.protectionEverActivated,
    required this.lifecycle,
    required this.plan,
    this.unlockEndsAt,
    this.unlockTimer,
  });

  /// -------------------------------
  /// Initial State
  /// -------------------------------

  factory PlanState.initial() {
    return PlanState(
      protectionEverActivated: false,
      lifecycle: ProtectionLifecycle.inactive,
      plan: UserPlan.free,
    );
  }

  /// -------------------------------
  /// Derived Getters
  /// -------------------------------

  bool get isProtectionInactive =>
      lifecycle == ProtectionLifecycle.inactive;

  bool get isProtectionActive =>
      lifecycle == ProtectionLifecycle.active;

  bool get isTemporarilyUnlocked =>
      lifecycle == ProtectionLifecycle.temporarilyUnlocked;

  bool get canRequestUnlock =>
      protectionEverActivated && isProtectionActive;

  bool get isPro => plan == UserPlan.pro;

  /// -------------------------------
  /// State Transitions
  /// -------------------------------

  void activateProtection() {
    protectionEverActivated = true;
    lifecycle = ProtectionLifecycle.active;
    notifyListeners();
  }

  void startTemporaryUnlock(Duration duration) {
    if (!canRequestUnlock) return;

    unlockEndsAt = DateTime.now().add(duration);
    lifecycle = ProtectionLifecycle.temporarilyUnlocked;
    notifyListeners();
  }

  void restoreProtection() {
    if (!protectionEverActivated) return;

    unlockEndsAt = null;
    unlockTimer?.cancel();
    unlockTimer = null;
    lifecycle = ProtectionLifecycle.active;
    notifyListeners();
  }
}
