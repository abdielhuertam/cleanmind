import 'package:flutter/foundation.dart';

enum UserPlan {
  free,
  pro,
}

class PlanState extends ChangeNotifier {
  UserPlan _plan = UserPlan.free;

  UserPlan get plan => _plan;

  bool get isPro => _plan == UserPlan.pro;

  void switchToPro() {
    _plan = UserPlan.pro;
    notifyListeners();
  }

  void switchToFree() {
    _plan = UserPlan.free;
    notifyListeners();
  }
}