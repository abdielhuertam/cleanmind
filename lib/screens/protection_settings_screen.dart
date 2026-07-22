import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../state/plan_state.dart';

import 'blocked_apps_screen.dart';
import 'custom_blocked_sites_screen.dart';
import 'support_screen.dart';

class ProtectionSettingsScreen
    extends StatelessWidget {
  final PlanState plan;
  final ValueChanged<PlanState> onPlanChanged;

  const ProtectionSettingsScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
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

            const SizedBox(
              height: 18,
            ),

            const SizedBox(
              height: 18,
            ),

            _sectionTitle(
              'Accountability',
            ),

            _settingsTile(
              icon:
                  Icons.people_outline,
              title:
                  'Support',
              subtitle:
                  'Manage your accountability partner and approval methods.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                          SupportScreen(
                            plan: plan,
                            onPlanChanged: onPlanChanged,
                          ),
                  ),
                );
              },
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
            fontSize: 16,
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
          vertical: 4,
        ),

        leading: Icon(
          icon,
          color:
              AppColors.primary,
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        subtitle: Padding(
          padding:
              const EdgeInsets.only(
            top: 2,
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