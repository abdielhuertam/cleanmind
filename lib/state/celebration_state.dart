enum CelebrationType {
  streak,
  levelUp,
}

class CelebrationState {
  final CelebrationType type;

  final String title;
  final String message;

  final int? streakDays;
  final int? level;

  final bool isPending;

  const CelebrationState({
    required this.type,
    required this.title,
    required this.message,
    this.streakDays,
    this.level,
    this.isPending = true,
  });

  factory CelebrationState.none() {
    return const CelebrationState(
      type: CelebrationType.streak,
      title: '',
      message: '',
      isPending: false,
    );
  }

  CelebrationState clear() {
    return const CelebrationState(
      type: CelebrationType.streak,
      title: '',
      message: '',
      isPending: false,
    );
  }
}