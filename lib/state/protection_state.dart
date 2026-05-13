enum ProtectionStatus {
  active,
  waitingPeriod,
  awaitingApproval,
  protectionDisabled,
  inactive,
}

class ProtectionState {
  final ProtectionStatus status;

  final DateTime activatedAt;

  final DateTime? deactivationScheduledAt;

  const ProtectionState({
    required this.status,
    required this.activatedAt,
    this.deactivationScheduledAt,
  });

  factory ProtectionState.active() {
    return ProtectionState(
      status: ProtectionStatus.active,
      activatedAt: DateTime.now(),
    );
  }

  factory ProtectionState.disabled() {
    return ProtectionState(
      status:
          ProtectionStatus
              .protectionDisabled,
      activatedAt: DateTime.now(),
    );
  }

  ProtectionState scheduleWaitingPeriod(
    Duration duration,
  ) {
    return ProtectionState(
      status:
          ProtectionStatus.waitingPeriod,
      activatedAt: activatedAt,
      deactivationScheduledAt:
          DateTime.now().add(duration),
    );
  }

  ProtectionState cancelDeactivation() {
    return ProtectionState(
      status: ProtectionStatus.active,
      activatedAt: activatedAt,
    );
  }

  ProtectionState disableProtection() {
    return ProtectionState(
      status:
          ProtectionStatus
              .protectionDisabled,
      activatedAt: activatedAt,
    );
  }

  bool isDeactivationExpired() {
    if (deactivationScheduledAt ==
        null) {
      return false;
    }

    return DateTime.now().isAfter(
      deactivationScheduledAt!,
    );
  }

  Duration? getRemainingDeactivationTime() {
    if (deactivationScheduledAt ==
        null) {
      return null;
    }

    final difference =
        deactivationScheduledAt!
            .difference(DateTime.now());

    if (difference.isNegative) {
      return Duration.zero;
    }

    return difference;
  }

  Duration getActiveDuration() {
    return DateTime.now().difference(
      activatedAt,
    );
  }
}