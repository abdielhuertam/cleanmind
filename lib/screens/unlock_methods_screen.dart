import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../theme/app_colors.dart';

class UnlockMethodsScreen
    extends StatelessWidget {
  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

  const UnlockMethodsScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isPro = plan.isPro;

    final requestPending =
        plan.unlockRequest.isPending;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Unlock Methods',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 28,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              'Choose how to disable protection',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 36),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.82,

                children: [
                  _MethodCard(
                    icon: Icons.edit_note,
                    label: 'Challenge',

                    enabled:
                        !requestPending,

                    onTap: () {
                      if (requestPending) {
                        return;
                      }

                      Navigator.pushNamed(
                        context,
                        '/copy-challenge',
                      );
                    },
                  ),

                  _MethodCard(
                    icon: Icons.schedule,
                    label:
                        'Waiting\nPeriod',

                    enabled:
                        !requestPending,

                    onTap: () {
                      if (requestPending) {
                        return;
                      }

                      final updatedPlan =
                          plan
                              .requestDeactivation();

                      onPlanChanged(
                        updatedPlan,
                      );

                      Navigator.pop(
                        context,
                      );
                    },
                  ),

                  _MethodCard(
                    icon: Icons.sms,
                    label: 'SMS Code',

                    enabled:
                        isPro &&
                        !requestPending,

                    premiumFeature: true,

                    onTap: () {
                      if (!isPro ||
                          requestPending) {
                        return;
                      }

                      Navigator.pushNamed(
                        context,
                        '/accountability-code',
                      );
                    },
                  ),

                  _MethodCard(
                    icon:
                        Icons.notifications_active,

                    label:
                        'Push\nNotification',

                    enabled:
                        isPro &&
                        !requestPending,

                    premiumFeature: true,

                    onTap: () {
                      if (!isPro ||
                          requestPending) {
                        return;
                      }

                      final updatedPlan =
                          plan
                              .startPushRequest();

                      onPlanChanged(
                        updatedPlan,
                      );

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Request sent.',
                          ),
                        ),
                      );

                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final bool premiumFeature;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
    this.premiumFeature = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        enabled
            ? Colors.white
            : Colors.grey.shade300;

    final iconColor =
        enabled
            ? AppColors.primary
            : Colors.grey;

    final textColor =
        enabled
            ? AppColors.textPrimary
            : Colors.grey;

    return GestureDetector(
      onTap: onTap,

      child: Opacity(
        opacity: enabled ? 1 : 0.65,

        child: Container(
          padding: const EdgeInsets.all(
            20,
          ),

          decoration: BoxDecoration(
            color: cardColor,

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

          child: Stack(
            children: [
              if (premiumFeature)
                Positioned(
                  right: 0,
                  child: Icon(
                    Icons.workspace_premium,
                    color:
                        Colors.amber.shade700,
                    size: 28,
                  ),
                ),

              Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  children: [
                    Icon(
                      icon,
                      size: 72,
                      color: iconColor,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Text(
                      label,
                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        fontSize: 18,
                        height: 1.2,

                        fontWeight:
                            FontWeight.w600,

                        color: textColor,
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
}