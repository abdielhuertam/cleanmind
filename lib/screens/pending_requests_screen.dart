import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../theme/app_colors.dart';

import '../widgets/request_card.dart';

class PendingRequestsScreen
    extends StatelessWidget {
  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

  const PendingRequestsScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasRequest =
        plan.unlockRequest.isPending;

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        backgroundColor:
            AppColors.primary,

        foregroundColor:
            Colors.white,

        elevation: 0,

        title: const Text(
          'Pending Requests',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(24),

        child: hasRequest
            ? Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),

                  RequestCard(
                    userName:
                        '<Usuario>',

                    onApprove: () {
                      final updatedPlan =
                          plan
                              .approvePushRequest();

                      onPlanChanged(
                        updatedPlan,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },

                    onReject: () {
                      final updatedPlan =
                          plan
                              .rejectPushRequest();

                      onPlanChanged(
                        updatedPlan,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                  ),
                ],
              )
            : const Center(
                child: Text(
                  'No pending requests.',

                  style: TextStyle(
                    fontSize: 18,

                    color:
                        AppColors
                            .textSecondary,
                  ),
                ),
              ),
      ),
    );
  }
}