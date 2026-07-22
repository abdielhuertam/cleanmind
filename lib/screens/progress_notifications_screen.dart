import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProgressNotificationsScreen extends StatefulWidget {
  const ProgressNotificationsScreen({
    super.key,
  });

  @override
  State<ProgressNotificationsScreen> createState() =>
      _ProgressNotificationsScreenState();
}

class _ProgressNotificationsScreenState
    extends State<ProgressNotificationsScreen> {
  bool milestoneCelebrations = true;
  bool levelUpNotifications = true;
  bool recurringReminder = false;

  int reminderDays = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Progress Notifications',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
        children: [

          _sectionTitle(
            'Achievements',
          ),

          _notificationCard(
            icon: Icons.emoji_events_outlined,
            title: 'Milestone Celebrations',
            subtitle:
                'Receive notifications when you reach CleanMind milestones and unlock new badges.',
            trailing: Switch(
              value: milestoneCelebrations,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  milestoneCelebrations = value;
                });
              },
            ),
          ),

          const SizedBox(height: 14),

          _notificationCard(
            icon: Icons.trending_up,
            title: 'Level Up Notifications',
            subtitle:
                'Receive a notification every time you gain a new level.',
            trailing: Switch(
              value: levelUpNotifications,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  levelUpNotifications = value;
                });
              },
            ),
          ),

          const SizedBox(height: 18),

          _sectionTitle(
            'Recurring Reminder',
          ),

          _notificationCard(
            icon: Icons.workspace_premium_outlined,
            title:
                'Recurring Progress Reminder',
            subtitle:
                'Receive periodic reminders showing your current streak and progress.',
            trailing: Switch(
              value: recurringReminder,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  recurringReminder = value;
                });
              },
            ),
          ),

          const SizedBox(height: 14),

          Opacity(
            opacity: recurringReminder ? 1 : .45,
            child: Container(
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
                crossAxisAlignment:
                    CrossAxisAlignment.start,
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
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),

                      const _ProBadge(),
                    ],
                  ),

                  const SizedBox(height: 14),

                  IgnorePointer(
                    ignoring: !recurringReminder,
                    child: Slider(
                      value: reminderDays.toDouble(),
                      min: 1,
                      max: 30,
                      divisions: 29,
                      activeColor: AppColors.primary,
                      label: '$reminderDays days',
                      onChanged: (value) {
                        setState(() {
                          reminderDays = value.round();
                        });
                      },
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Every $reminderDays day${reminderDays == 1 ? '' : 's'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

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

                    const SizedBox(height: 2),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.35,
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
