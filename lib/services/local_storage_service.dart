import 'package:shared_preferences/shared_preferences.dart';
import '../state/plan_state.dart';
import '../state/protection_state.dart';

class LocalStorageService {
  static const _statusKey = 'protection_status';
  static const _activatedAtKey = 'activated_at';
  static const _isProKey = 'is_pro';
  static const _deactivationScheduledAtKey =
      'deactivation_scheduled_at';

  static Future<void> savePlan(PlanState plan) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
        _statusKey, plan.protection.status.index);

    await prefs.setBool(_isProKey, plan.isPro);

    if (plan.protection.activatedAt != null) {
      await prefs.setInt(
        _activatedAtKey,
        plan.protection.activatedAt!
            .millisecondsSinceEpoch,
      );
    } else {
      await prefs.remove(_activatedAtKey);
    }

    if (plan.protection.deactivationScheduledAt != null) {
      await prefs.setInt(
        _deactivationScheduledAtKey,
        plan.protection.deactivationScheduledAt!
            .millisecondsSinceEpoch,
      );
    } else {
      await prefs.remove(_deactivationScheduledAtKey);
    }
  }

  static Future<PlanState> loadPlan() async {
    final prefs = await SharedPreferences.getInstance();

    final statusIndex =
        prefs.getInt(_statusKey) ??
            ProtectionStatus.inactive.index;

    final isPro = prefs.getBool(_isProKey) ?? false; //Change Pro or Free plan

    final activatedAtMillis =
        prefs.getInt(_activatedAtKey);

    final deactivationScheduledAtMillis =
        prefs.getInt(_deactivationScheduledAtKey);

    final protection = ProtectionState(
      status: ProtectionStatus.values[statusIndex],
      activatedAt: activatedAtMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(
              activatedAtMillis)
          : null,
      deactivationScheduledAt:
          deactivationScheduledAtMillis != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  deactivationScheduledAtMillis)
              : null,
    );

    return PlanState(
      protection: protection,
      isPro: isPro,
    );
  }
}
