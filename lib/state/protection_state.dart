enum ProtectionStatus {
  inactive,
  active,
  deactivationPending,
  protectionDisabled,
}

const Duration kFreeDeactivationDuration = Duration(minutes: 1);

class ProtectionState {
  final ProtectionStatus status;
  final DateTime? activatedAt;
  final DateTime? deactivationScheduledAt;

  const ProtectionState({
    required this.status,
    this.activatedAt,
    this.deactivationScheduledAt,
  });

  ProtectionState activate() {
    return ProtectionState(
      status: ProtectionStatus.active,
      activatedAt: DateTime.now(),
      deactivationScheduledAt: null,
    );
  }

  ProtectionState scheduleDeactivation() {
    return ProtectionState(
      status: ProtectionStatus.deactivationPending,
      activatedAt: activatedAt,
      deactivationScheduledAt: DateTime.now(),
    );
  }

  ProtectionState cancelScheduledDeactivation() {
    return ProtectionState(
      status: ProtectionStatus.active,
      activatedAt: activatedAt,
      deactivationScheduledAt: null,
    );
  }

  ProtectionState disable() {
    return ProtectionState(
      status: ProtectionStatus.protectionDisabled,
      activatedAt: null,
      deactivationScheduledAt: null,
    );
  }

  Duration getActiveDuration() {
    if (activatedAt == null) return Duration.zero;
    return DateTime.now().difference(activatedAt!);
  }

  Duration? getRemainingDeactivationTime() {
    if (status != ProtectionStatus.deactivationPending ||
        deactivationScheduledAt == null) {
      return null;
    }

    final elapsed = DateTime.now().difference(deactivationScheduledAt!);
    final remaining = kFreeDeactivationDuration - elapsed;

    if (remaining.isNegative) return Duration.zero;
    return remaining;
  }

  bool isDeactivationExpired() {
    if (status != ProtectionStatus.deactivationPending ||
        deactivationScheduledAt == null) {
      return false;
    }

    final elapsed = DateTime.now().difference(deactivationScheduledAt!);
    return elapsed >= kFreeDeactivationDuration;
  }
}
