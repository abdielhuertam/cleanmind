import 'dart:async';
import 'package:flutter/foundation.dart';

enum ProtectionStatus {
  protectionOn,
  temporaryUnlockActive,
  protectionOffError,
}

class ProtectionState extends ChangeNotifier {
  ProtectionStatus _status = ProtectionStatus.protectionOn;
  Duration _remainingUnlock = Duration.zero;
  Timer? _timer;

  ProtectionStatus get status => _status;
  Duration get remainingUnlock => _remainingUnlock;

  void requestTemporaryUnlock({Duration duration = const Duration(hours: 1)}) {
    _timer?.cancel();

    _status = ProtectionStatus.temporaryUnlockActive;
    _remainingUnlock = duration;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingUnlock.inSeconds <= 1) {
        timer.cancel();
        _restoreProtection();
      } else {
        _remainingUnlock -= const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  void _restoreProtection() {
    _status = ProtectionStatus.protectionOn;
    _remainingUnlock = Duration.zero;
    notifyListeners();
  }

  void enableProtectionFromError() {
    _status = ProtectionStatus.protectionOn;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}