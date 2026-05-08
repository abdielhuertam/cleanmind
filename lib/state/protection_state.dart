enum ProtectionStatus {
  inactive,
  active,
  waitingPeriod,
  awaitingApproval,
  protectionDisabled,
}

class ProtectionState {
  final ProtectionStatus status;
  final DateTime? activatedAt;
  final DateTime? deactivationScheduledAt;
  final Duration? deactivationDuration;

  const ProtectionState({
    required this.status,
    this.activatedAt,
    this.deactivationScheduledAt,
    this.deactivationDuration,
  });

  ProtectionState activate() {
    return ProtectionState(
      status: ProtectionStatus.active,
      activatedAt: DateTime.now(),
      deactivationScheduledAt: null,
      deactivationDuration: null,
    );
  }

ProtectionState scheduleWaitingPeriod(Duration duration) {
  return ProtectionState(
    status: ProtectionStatus.waitingPeriod,
    activatedAt: activatedAt,
    deactivationScheduledAt: DateTime.now(),
    deactivationDuration: duration,
  );
}

  ProtectionState cancelScheduledDeactivation() {
    return ProtectionState(
      status: ProtectionStatus.active,
      activatedAt: activatedAt,
      deactivationScheduledAt: null,
      deactivationDuration: null,
    );
  }

  ProtectionState disable() {
    return ProtectionState(
      status: ProtectionStatus.protectionDisabled,
      activatedAt: null,
      deactivationScheduledAt: null,
      deactivationDuration: null,
    );
  }

  Duration getActiveDuration() {
    if (activatedAt == null) return Duration.zero;
    return DateTime.now().difference(activatedAt!);
  }

  Duration? getRemainingDeactivationTime() {
    if (status != ProtectionStatus.waitingPeriod ||
        deactivationScheduledAt == null ||
        deactivationDuration == null) {
      return null;
    }

    final elapsed = DateTime.now().difference(deactivationScheduledAt!);
    final remaining = deactivationDuration! - elapsed;

    if (remaining.isNegative) return Duration.zero;
    return remaining;
  }

  bool isDeactivationExpired() {
    if (status != ProtectionStatus.waitingPeriod ||
        deactivationScheduledAt == null ||
        deactivationDuration == null) {
      return false;
    }

    final elapsed = DateTime.now().difference(deactivationScheduledAt!);
    return elapsed >= deactivationDuration!;
  }

  ProtectionState requestApproval() {
  return ProtectionState(
    status: ProtectionStatus.awaitingApproval,
    activatedAt: activatedAt,
    deactivationScheduledAt: null,
  );
}

  bool get isProtectionDisabled =>
      status == ProtectionStatus.protectionDisabled;
}