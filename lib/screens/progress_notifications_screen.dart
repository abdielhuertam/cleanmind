import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../state/plan_state.dart';
import '../services/local_storage_service.dart';

import '../services/notification_service.dart';

class ProgressNotificationsScreen extends StatefulWidget {
  final PlanState plan;
  final ValueChanged<PlanState> onPlanChanged;

  const ProgressNotificationsScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  State<ProgressNotificationsScreen> createState() =>
      _ProgressNotificationsScreenState();
}

class _ProgressNotificationsScreenState
    extends State<ProgressNotificationsScreen> {
    
    late PlanState _plan;

    @override
    void initState() {
      super.initState();
      _plan = widget.plan;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications Settings',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
        children: [

      const SizedBox(height: 10),

      _sectionTitle(
        'Protection',
      ),

      _notificationCard(
        icon: Icons.timer_outlined,
        title: 'Partial Protection Reminder',
        subtitle:
            'Receive a notification when your Partial Protection session ends.',
        trailing: Switch(
          value:
              _plan.partialProtectionNotificationsEnabled,
          activeColor: AppColors.primary,
          onChanged: (value) async {
            final updated = _plan.copyWith(
              partialProtectionNotificationsEnabled:
                  value,
            );

            await _savePlan(updated);
          },
        ),
      ),

      const SizedBox(height: 10),
      
          _sectionTitle(
            'Recurring Reminder',
          ),

          _notificationCard(
            icon: Icons.workspace_premium_outlined,
            title:
                'Recurring Progress Reminder',
            subtitle:
                'Receive periodic reminders showing your current streak and progress.',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _ProBadge(),
                const SizedBox(width: 8),
                Switch(
              value: _plan.recurringProgressReminderEnabled,
              activeColor: AppColors.primary,
              onChanged: (value) async {
                final updated = _plan.copyWith(
                  recurringProgressReminderEnabled: value,
                );

                if (value) {
                  await NotificationService
                      .scheduleRecurringProgressReminder(
                    duration: Duration(
                      days: updated.recurringReminderDays,
                    ),
                  );
                } else {
                  await NotificationService
                      .cancelRecurringProgressReminder();
                }

                await _savePlan(updated);
                },
                    ),
                  ],
                ),
          ),

          if (_plan.recurringProgressReminderEnabled) ...[
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),  
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_outlined,
                        color: AppColors.primary,
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          'Reminder Interval',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Slider(
                    value: _plan.recurringReminderDays.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    activeColor: AppColors.primary,
                    label: '${_plan.recurringReminderDays} days',
                    onChanged: (value) async {
                      final updated = _plan.copyWith(
                        recurringReminderDays: value.round(),
                      );

                      if (updated.recurringProgressReminderEnabled) {
                        await NotificationService.cancelRecurringProgressReminder();

                        await NotificationService.scheduleRecurringProgressReminder(
                          duration: Duration(
                            days: updated.recurringReminderDays,
                          ),
                        );
                      }

                      await _savePlan(updated);
                    },
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Every ${_plan.recurringReminderDays} day${_plan.recurringReminderDays == 1 ? '' : 's'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
          Container(
            padding:
                const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(
                0xFFF8F9FB,
              ),
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
            child: const Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Icon(
                  Icons.info_outline,
                  color:
                      AppColors.primary,
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Recurring Progress Reminder is available with CleanMind PRO.',
                    style: TextStyle(
                      height: 1.4,
                      color:
                          AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _savePlan(
    PlanState plan,
  ) async {
    setState(() {
      _plan = plan;
    });

    widget.onPlanChanged(plan);

    await LocalStorageService.savePlan(plan);
  }

  Widget _sectionTitle(
    String title,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight:
              FontWeight.bold,
          color:
              AppColors.primary,
        ),
      ),
    );
  }

  Widget _notificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 1),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.2,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              trailing,
            ],
          ),
        ],
      ),
    );
  }
}

class _ProBadge
    extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color:
            AppColors.primary,
        borderRadius:
            BorderRadius.circular(
          30,
        ),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          color: Colors.white,
          fontWeight:
              FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
