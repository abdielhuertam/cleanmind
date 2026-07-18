enum SupportRequestStatus {
  none,
  pending,
  approved,
  rejected,
}

class SupportRequestState {
  final SupportRequestStatus status;
  final String? requesterName;
  final String? requestId;

  const SupportRequestState({
    required this.status,
    this.requesterName,
    this.requestId,
  });

  factory SupportRequestState.none() {
    return const SupportRequestState(
      status: SupportRequestStatus.none,
    );
  }

  bool get isPending =>
      status == SupportRequestStatus.pending;

  SupportRequestState createPending({
    required String requesterName,
  }) {
    return SupportRequestState(
      status: SupportRequestStatus.pending,
      requesterName: requesterName,
      requestId:
          DateTime.now().microsecondsSinceEpoch.toString(),
    );
  }

  SupportRequestState approve() {
    return const SupportRequestState(
      status: SupportRequestStatus.approved,
    );
  }

  SupportRequestState reject() {
    return const SupportRequestState(
      status: SupportRequestStatus.rejected,
    );
  }

  SupportRequestState clear() {
    return SupportRequestState.none();
  }
}