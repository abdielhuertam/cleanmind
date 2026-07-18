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
  final String? requesterName;

  const UnlockRequestState({
    required this.status,
    this.createdAt,
    this.expiresAt,
    this.requesterName,
  });

  factory UnlockRequestState.none() {
    return const UnlockRequestState(
      status: UnlockRequestStatus.none,
    );
  }

  UnlockRequestState createPending({
    required Duration duration,
    required String requesterName,
  }){
    final now = DateTime.now();

    return UnlockRequestState(
      status: UnlockRequestStatus.pending,
      createdAt: now,
      expiresAt: now.add(duration),
      requesterName: requesterName,
    );
  }

  UnlockRequestState approve() {
    return UnlockRequestState(
      status: UnlockRequestStatus.approved,
      createdAt: createdAt,
      expiresAt: expiresAt,
      requesterName: requesterName,
    );
  }

  UnlockRequestState reject() {
    return UnlockRequestState(
      status: UnlockRequestStatus.rejected,
      createdAt: createdAt,
      expiresAt: expiresAt,
      requesterName: requesterName,
    );
  }

  UnlockRequestState expire() {
    return UnlockRequestState.none();
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