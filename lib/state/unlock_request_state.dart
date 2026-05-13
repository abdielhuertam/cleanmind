enum UnlockRequestStatus {
  none,
  pending,
  approved,
  rejected,
  expired,
}

class UnlockRequestState {
  final UnlockRequestStatus status;

  final DateTime? createdAt;
  final DateTime? expiresAt;

  const UnlockRequestState({
    required this.status,
    this.createdAt,
    this.expiresAt,
  });

  factory UnlockRequestState.none() {
    return const UnlockRequestState(
      status: UnlockRequestStatus.none,
    );
  }

  UnlockRequestState createPending({
    required Duration duration,
  }) {
    final now = DateTime.now();

    return UnlockRequestState(
      status: UnlockRequestStatus.pending,
      createdAt: now,
      expiresAt: now.add(duration),
    );
  }

  UnlockRequestState approve() {
    return UnlockRequestState(
      status: UnlockRequestStatus.approved,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }

  UnlockRequestState reject() {
    return UnlockRequestState(
      status: UnlockRequestStatus.rejected,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }

  UnlockRequestState expire() {
    return UnlockRequestState(
      status: UnlockRequestStatus.expired,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }

  UnlockRequestState cancel() {
    return UnlockRequestState.none();
  }

  bool get isPending =>
      status == UnlockRequestStatus.pending;

  bool isExpired() {
    if (expiresAt == null) return false;

    return DateTime.now().isAfter(
      expiresAt!,
    );
  }

  Duration? getRemainingTime() {
    if (expiresAt == null) return null;

    final difference =
        expiresAt!.difference(
      DateTime.now(),
    );

    if (difference.isNegative) {
      return Duration.zero;
    }

    return difference;
  }
}