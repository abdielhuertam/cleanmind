enum ProtectionStatus {
  inactive,
  active,
  deactivationPending,
  protectionDisabled,
}

class ProtectionState {
  final ProtectionStatus status;
  final DateTime? activatedAt;

  const ProtectionState({
    required this.status,
    this.activatedAt,
  });

  factory ProtectionState.initial() {
    return const ProtectionState(
      status: ProtectionStatus.inactive,
      activatedAt: null,
    );
  }

  // KEEP ORIGINAL METHOD NAME
  ProtectionState activate() {
    return ProtectionState(
      status: ProtectionStatus.active,
      activatedAt: DateTime.now(),
    );
  }

  // KEEP ORIGINAL METHOD NAME
  ProtectionState requestDeactivation() {
    return ProtectionState(
      status: ProtectionStatus.deactivationPending,
      activatedAt: activatedAt,
    );
  }

  // KEEP ORIGINAL METHOD NAME
  ProtectionState disable() {
    return const ProtectionState(
      status: ProtectionStatus.protectionDisabled,
      activatedAt: null,
    );
  }

  // Manual reactivation (used in HomeScreen)
  ProtectionState manualReactivate() {
    return ProtectionState(
      status: ProtectionStatus.active,
      activatedAt: DateTime.now(),
    );
  }

  Duration getActiveDuration() {
    if (activatedAt == null) {
      return Duration.zero;
    }
    return DateTime.now().difference(activatedAt!);
  }
}
