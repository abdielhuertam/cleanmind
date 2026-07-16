import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../theme/app_colors.dart';

import '../services/notification_service.dart';

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

  Future<bool> _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String description,
    required String warning,
    required String confirmText,
  }) async {
    final result = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              24,
            ),
          ),

          title: Text(
            title,

            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,

              color:
                  AppColors.textPrimary,
            ),
          ),

          content: Column(
            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                description,

                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(
                  12,
                ),

                decoration: BoxDecoration(
                  color:
                      Colors.red.shade50,

                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),

                child: Text(
                  warning,

                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color:
                        Colors.red.shade700,

                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },

              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primary,

                foregroundColor:
                    Colors.white,
              ),

              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },

              child: Text(
                confirmText,
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isPro = plan.isPro;

    final requestPending =
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
          'Unlock Methods',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 22,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              'Choose how to disable protection',

              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,

                color:
                    AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,

                crossAxisSpacing: 14,
                mainAxisSpacing: 14,

                childAspectRatio: 1.10,

                children: [
                  _MethodCard(
                    icon: Icons.edit_note,

                    label:
                        'Challenge',

                    enabled:
                        !requestPending,

                      onTap: () async {
                        if (requestPending) {
                          return;
                        }

                        if (!context.mounted) {
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

                    onTap: () async {
                      if (requestPending) {
                        return;
                      }

                      final duration =
                          isPro
                              ? '1 hour'
                              : '8 hours';

                      final confirmed =
                          await _showConfirmationDialog(
                        context: context,

                        title:
                            'Start Waiting Period?',

                        description:
                            'Protection will remain active during the countdown.',

                        warning:
                            'When the waiting period ends, protection will disable automatically and your progress streak will reset.\n\nWaiting duration: $duration.',

                        confirmText:
                            'Start',
                      );

                      if (!confirmed) {
                        return;
                      }

                      final updatedPlan =
                          plan.requestDeactivation();

                    await NotificationService.scheduleWaitingPeriod(
                      duration: isPro
                          ? const Duration(hours: 1)
                          : const Duration(hours: 8),
                    );

                      onPlanChanged(
                        updatedPlan,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.pop(
                        context,
                      );
                    },
                  ),

                  _MethodCard(
                    icon: Icons.sms,

                    label:
                        'SMS Code',

                    enabled:
                        isPro &&
                        !requestPending,

                    premiumFeature: true,

                    onTap: () async {
                      if (!isPro) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Available in CleanMind Pro.',
                            ),
                          ),
                        );
                        return;
                      }

                      if (requestPending) {
                        return;
                      }
                      if (!context.mounted) {
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

                    onTap: () async {
                      if (!isPro) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Available in CleanMind Pro.',
                            ),
                          ),
                        );
                        return;
                      }

                      if (requestPending) {
                        return;
                      }

                      final confirmed =
                          await _showConfirmationDialog(
                        context: context,

                        title:
                            'Send Unlock Request?',

                        description:
                            'Your Support will receive an approval request.',

                        warning:
                            'Protection remains active until your Support approves the request. If approved, your progress streak will reset.',

                        confirmText:
                            'Send Request',
                      );

                      if (!confirmed) {
                        return;
                      }

                      final updatedPlan =
                          plan
                              .startPushRequest();

                      onPlanChanged(
                        updatedPlan,
                      );

                      if (!context.mounted) {
                        return;
                      }

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
        opacity:
            enabled ? 1 : 0.5,

        child: Container(
          padding:
              const EdgeInsets.all(
            12,
          ),

          decoration: BoxDecoration(
            color: cardColor,

            borderRadius:
                BorderRadius.circular(
              22,
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

                    size: 24,
                  ),
                ),

              if (!enabled && !premiumFeature)
                Positioned(
                  left: 0,
                  top: 0,

                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.orange,

                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),

                    child: const Text(
                      'Pending',

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 11,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (premiumFeature && !enabled)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

                      size: 50,

                      color: iconColor,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      label,

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        fontSize: 15,
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