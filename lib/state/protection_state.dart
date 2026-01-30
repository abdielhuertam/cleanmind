import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ProtectionStatus {
  protectionOn,
  temporaryUnlockActive,
  protectionOffError,
}

class ProtectionState extends ChangeNotifier {
  // ===== DEVELOPMENT CONFIG =====
  // Short duration used ONLY for local testing
  static const bool _devMode = true;
  static const Duration _devUnlockDuration = Duration(seconds: 10);

  static const _keyStatus = 'protection_status';
  static const _keyUnlockEndTs = 'unlock_end_timestamp';

  ProtectionStatus _status = ProtectionStatus.protectionOn;
  Duration _remainingUnlock = Duration.zero;
  Timer? _timer;

  ProtectionStatus get status => _status;
  Duration get remainingUnlock => _remainingUnlock;

  ProtectionState() {
    ProtectionState() {
        if (_devMode) {
            _resetForDevelopment();
        } else {
            _restoreFromStorage();
        }
    }

  }

  // ===== PUBLIC API =====

  void requestTemporaryUnlock({
    Duration duration = const Duration(hours: 1),
    required bool isProUser,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (!isProUser && !_devMode) {
    final todayKey = _todayKey();
    final usedToday = prefs.getBool(todayKey) ?? false;

    if (usedToday) {
        return;
    }

    await prefs.setBool(todayKey, true);
    }

    final effectiveDuration =
        _devMode ? _devUnlockDuration : duration;

    final endTs =
        DateTime.now().add(effectiveDuration).millisecondsSinceEpoch;

    _startUnlock(endTs);
  }

  void enableProtectionFromError() {
    _setStatus(ProtectionStatus.protectionOn);
    _clearStoredUnlock();
  }

  // ===== INTERNAL LOGIC =====

Future<void> _resetForDevelopment() async {
  final prefs = await SharedPreferences.getInstance();

  // Clear unlock state
  await prefs.remove(_keyUnlockEndTs);
  await prefs.setInt(_keyStatus, ProtectionStatus.protectionOn.index);

  // Clear daily Free-plan lock
  final todayKey = _todayKey();
  await prefs.remove(todayKey);

  _status = ProtectionStatus.protectionOn;
  _remainingUnlock = Duration.zero;
  notifyListeners();
}



  Future<void> _restoreFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final statusIndex = prefs.getInt(_keyStatus);
    final endTs = prefs.getInt(_keyUnlockEndTs);

    if (statusIndex == null) {
      _setStatus(ProtectionStatus.protectionOn, persist: false);
      return;
    }

    _status = ProtectionStatus.values[statusIndex];

    if (_status == ProtectionStatus.temporaryUnlockActive && endTs != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (endTs > now) {
        _startUnlock(endTs, persist: false);
      } else {
        _restoreProtection(persist: false);
      }
    } else {
      notifyListeners();
    }
  }

  void _startUnlock(int endTimestampMs, {bool persist = true}) {
    _timer?.cancel();

    final now = DateTime.now().millisecondsSinceEpoch;
    _remainingUnlock =
        Duration(milliseconds: (endTimestampMs - now).clamp(0, 1 << 31));

    _status = ProtectionStatus.temporaryUnlockActive;

    if (persist) {
      _persistStatus(endTimestampMs);
    }

    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final remainingMs = endTimestampMs - now;

      if (remainingMs <= 0) {
        timer.cancel();
        _restoreProtection();
      } else {
        _remainingUnlock = Duration(milliseconds: remainingMs);
        notifyListeners();
      }
    });
  }

  void _restoreProtection({bool persist = true}) {
    _timer?.cancel();
    _remainingUnlock = Duration.zero;
    _setStatus(ProtectionStatus.protectionOn, persist: persist);
    if (persist) _clearStoredUnlock();
  }

  void _setStatus(ProtectionStatus status, {bool persist = true}) async {
    _status = status;
    if (persist) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyStatus, status.index);
    }
    notifyListeners();
  }

  Future<void> _persistStatus(int endTimestampMs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        _keyStatus, ProtectionStatus.temporaryUnlockActive.index);
    await prefs.setInt(_keyUnlockEndTs, endTimestampMs);
  }

  Future<void> _clearStoredUnlock() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUnlockEndTs);
    await prefs.setInt(_keyStatus, ProtectionStatus.protectionOn.index);
  }

  String _todayKey() {
    final now = DateTime.now();
    return 'unlock_used_${now.year}_${now.month}_${now.day}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}