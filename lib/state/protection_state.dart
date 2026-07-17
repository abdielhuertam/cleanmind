enum ProtectionStatus {
  active,
  awaitingApproval,
  protectionDisabled,
  inactive,
}

enum ProtectionMode {
  permanent,
  partial,
}

class ProtectionState {
  final ProtectionStatus status;

  final ProtectionMode mode;

  final DateTime activatedAt;

  final DateTime? expiresAt;

  const ProtectionState({
    required this.status,
    required this.mode,
    required this.activatedAt,
    this.expiresAt,
  });

  factory ProtectionState.active({
    ProtectionMode mode =
        ProtectionMode.permanent,
    DateTime? expiresAt,
  }) {
    return ProtectionState(
      status: ProtectionStatus.active,
      mode: mode,
      activatedAt: DateTime.now(),
      expiresAt: expiresAt,
    );
  }

  factory ProtectionState.disabled() {
    return ProtectionState(
      status:
          ProtectionStatus
              .protectionDisabled,
      mode: ProtectionMode.permanent,
      activatedAt: DateTime.now(),
    );
  }

  ProtectionState disableProtection() {
    return ProtectionState(
      status:
          ProtectionStatus
              .protectionDisabled,
      mode: mode,
      activatedAt: activatedAt,
    );
  }

  bool isPartialExpired() {
    if (mode !=
        ProtectionMode.partial) {
      return false;
    }

    if (expiresAt == null) {
      return false;
    }

    return DateTime.now().isAfter(
      expiresAt!,
    );
  }

  Duration? getRemainingPartialTime() {
    if (expiresAt == null) {
      return null;
    }

    final difference =
        expiresAt!.difference(
      DateTime.now(),
    );

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