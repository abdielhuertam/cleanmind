import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../state/unlock_request_state.dart';

import '../theme/app_colors.dart';

import '../widgets/request_card.dart';

import '../services/protection_service.dart';

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
    final request =
        plan.unlockRequest;

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

        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),

              if (request.status ==
                  UnlockRequestStatus
                      .pending)
                RequestCard(
                  userName:
                      '<Usuario>',

                  onApprove: () async {
                    final updatedPlan =
                        await ProtectionService.unlockSucceeded(
                      plan: plan,
                    );

                    onPlanChanged(
                      updatedPlan,
                    );
                  },

                  onReject: () {
                    final updatedPlan =
                        plan
                            .rejectPushRequest();

                    onPlanChanged(
                      updatedPlan,
                    );
                  },
                ),

              if (request.status ==
                  UnlockRequestStatus
                      .approved)
                _statusCard(
                  icon:
                      Icons.check_circle,

                  iconColor:
                      Colors.green,

                  title:
                      'Request Approved',

                  message:
                      'Protection has been disabled successfully.',

                  background:
                      Colors.green
                          .shade50,
                ),

              if (request.status ==
                  UnlockRequestStatus
                      .rejected)
                _statusCard(
                  icon: Icons.cancel,

                  iconColor:
                      AppColors.danger,

                  title:
                      'Request Rejected',

                  message:
                      'Protection remains active and the unlock request was denied.',

                  background:
                      Colors.red
                          .shade50,
                ),

              if (request.status ==
                  UnlockRequestStatus
                      .expired)
                _statusCard(
                  icon:
                      Icons.schedule,

                  iconColor:
                      Colors.orange,

                  title:
                      'Request Expired',

                  message:
                      'No approval was received before the request expired.',

                  background:
                      Colors.orange
                          .shade50,
                ),

              if (request.status ==
                  UnlockRequestStatus
                      .none)
                Container(
                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(
                    28,
                  ),

                  decoration:
                      BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      28,
                    ),

                    boxShadow: const [
                      BoxShadow(
                        color:
                            Colors.black12,

                        blurRadius: 10,

                        offset:
                            Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    children: const [
                      Icon(
                        Icons.notifications_off,

                        size: 64,

                        color:
                            AppColors
                                .textSecondary,
                      ),

                      SizedBox(
                        height: 18,
                      ),

                      Text(
                        'No Pending Requests',

                        style:
                            TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight
                                  .bold,

                          color:
                              AppColors
                                  .textPrimary,
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Text(
                        'New unlock approval requests will appear here.',

                        textAlign:
                            TextAlign.center,

                        style:
                            TextStyle(
                          fontSize: 16,

                          height: 1.4,

                          color:
                              AppColors
                                  .textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required Color background,
  }) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(
        28,
      ),

      decoration: BoxDecoration(
        color: background,

        borderRadius:
            BorderRadius.circular(
          28,
        ),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Icon(
            icon,

            size: 72,

            color: iconColor,
          ),

          const SizedBox(height: 22),

          Text(
            title,

            textAlign:
                TextAlign.center,

            style: TextStyle(
              fontSize: 26,
              fontWeight:
                  FontWeight.bold,

              color: iconColor,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            message,

            textAlign:
                TextAlign.center,

            style: const TextStyle(
              fontSize: 17,
              height: 1.45,

              color:
                  AppColors
                      .textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}