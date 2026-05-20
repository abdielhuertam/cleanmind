import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import 'custom_blocked_sites_screen.dart';
import 'waiting_period_screen.dart';
import '../state/plan_state.dart';
import 'waiting_period_screen.dart';
import 'blocked_apps_screen.dart';

class ProtectionSettingsScreen
    extends StatelessWidget {

  final PlanState plan;

  const ProtectionSettingsScreen({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
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
          'Protection Settings',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),

        child: ListView(
          children: [
            _sectionTitle(
              'Protection',
            ),

            _settingsTile(
              icon:
                  Icons.apps,

              title:
                  'Blocked Apps',

              subtitle:
                  'Manage protected applications and distractions.',

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            BlockedAppsScreen(
                              plan: plan,
                            ),
                  ),
                );
              },
            ),

            _settingsTile(
              icon:
                  Icons.language,

              title:
                  'Custom Blocked Sites',

              subtitle:
                  'Add websites or URLs to block manually.',

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            CustomBlockedSitesScreen(
                              plan: plan,
                            ),
                  ),
                );
              },
            ),

            _settingsTile(
              icon:
                  Icons.schedule,

              title:
                  'Waiting Period',

              subtitle:
                  'Configure unlock delay duration.',

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            const WaitingPeriodScreen(),
                  ),
                );
              },
            ),

            _settingsTile(
              icon:
                  Icons.lock_outline,

              title:
                  'Strict Mode',

              subtitle:
                  'Prevent accidental disabling of protection.',

              trailing:
                  Switch(
                value: true,

                activeColor:
                    AppColors.primary,

                onChanged: (_) {},
              ),
            ),

            const SizedBox(
              height: 26,
            ),

            _sectionTitle(
              'Notifications',
            ),

            _settingsTile(
              icon:
                  Icons.notifications,

              title:
                  'Daily Reminders',

              subtitle:
                  'Receive protection and focus reminders.',

              trailing:
                  Switch(
                value: true,

                activeColor:
                    AppColors.primary,

                onChanged: (_) {},
              ),
            ),

            _settingsTile(
              icon:
                  Icons.local_fire_department,

              title:
                  'Streak Alerts',

              subtitle:
                  'Celebrate focus milestones and progress.',

              trailing:
                  Switch(
                value: true,

                activeColor:
                    AppColors.primary,

                onChanged: (_) {},
              ),
            ),

            const SizedBox(
              height: 26,
            ),

            _sectionTitle(
              'Advanced',
            ),

            _settingsTile(
              icon:
                  Icons.security,

              title:
                  'Unlock Methods',

              subtitle:
                  'Manage approval and verification methods.',
            ),

            _settingsTile(
              icon:
                  Icons.info_outline,

              title:
                  'About CleanMind',

              subtitle:
                  'App version and protection details.',
            ),

            const SizedBox(
              height: 24,
            ),
          ],
        ),
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

      child: Align(
        alignment:
            Alignment.centerLeft,

        child: Text(
          title,

          style: const TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,

            color:
                AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),

        leading: Icon(
          icon,

          color:
              AppColors.primary,
        ),

        title: Text(
          title,

          style: const TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        subtitle: Padding(
          padding:
              const EdgeInsets.only(
            top: 6,
          ),

          child: Text(
            subtitle,

            style: const TextStyle(
              height: 1.35,
            ),
          ),
        ),

        trailing:
            trailing ??
            const Icon(
              Icons.arrow_forward_ios,

              size: 18,

              color:
                  AppColors.primary,
            ),

        onTap: onTap,
      ),
    );
  }
}