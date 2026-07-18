import '../state/plan_state.dart';
import '../state/protection_state.dart';
import 'notification_service.dart';

class ProtectionService {
  ProtectionService._();

  static Future<PlanState> activatePartialProtection({
    required PlanState plan,
    required DateTime expiresAt,
  }) async {
    final updatedPlan =
        plan.activatePartialProtection(
      expiresAt,
    );

    await NotificationService.schedulePartialProtection(
      duration: expiresAt.difference(
        DateTime.now(),
      ),
    );

    return updatedPlan;
  }

  static Future<PlanState> unlockSucceeded({
    required PlanState plan,
  }) async {
    await NotificationService.cancelPartialProtection();

    return plan.unlockSucceeded();
  }

  static Future<PlanState> manualReactivate({
    required PlanState plan,
  }) async {
    await NotificationService.cancelPartialProtection();

    return plan.manualReactivate();
  }

  static Future<PlanState> startPushRequest({
    required PlanState plan,
    required String requesterName,
  }) async {
    return plan.startPushRequest(
      requesterName: requesterName,
    );
  }
}