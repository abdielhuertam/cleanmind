import 'package:flutter/foundation.dart';

class BlockState extends ChangeNotifier {
  Duration? _selectedDuration;
  bool _isBlocking = false;

  Duration? get selectedDuration => _selectedDuration;
  bool get isBlocking => _isBlocking;

  void setDuration(Duration duration) {
    _selectedDuration = duration;
    notifyListeners();
  }

  void startBlocking() {
    if (_selectedDuration == null) return;

    _isBlocking = true;
    notifyListeners();

    // 🔜 aquí luego irá:
    // - inicio de VPN
    // - timer
    // - persistencia
  }

  void stopBlocking() {
    _isBlocking = false;
    notifyListeners();
  }
}
