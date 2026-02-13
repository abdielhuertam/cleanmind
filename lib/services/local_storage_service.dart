import 'package:shared_preferences/shared_preferences.dart';
import '../state/plan_state.dart';
import '../state/protection_state.dart';

class LocalStorageService {
  static const _statusKey = 'protection_status';
  static const _activatedAtKey = 'activated_at';
  static const _isProKey = 'is_pro';

  static Future<void> savePlan(PlanState plan) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
        _statusKey, plan.protection.status.index);

    if (plan.protection.activatedAt != null) {
      await prefs.setInt(
        _activatedAtKey,
        plan.protection.activatedAt!.millisecondsSinceEpoch,
      );
    } else {
      await prefs.remove(_activatedAtKey);
    }

    await prefs.setBool(_isProKey, plan.isPro);
  }

  static Future<PlanState> loadPlan() async {
    final prefs = await SharedPreferences.getInstance();

    final statusIndex =
        prefs.getInt(_statusKey) ??
            ProtectionStatus.inactive.index;

    final activatedMillis =
        prefs.getInt(_activatedAtKey);

    final isPro = prefs.getBool(_isProKey) ?? false;

    final status =
        ProtectionStatus.values[statusIndex];

    final protection = ProtectionState(
      status: status,
      activatedAt: activatedMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(
              activatedMillis)
          : null,
    );

    return PlanState(
      protection: protection,
      isPro: isPro,
    );
  }
}
