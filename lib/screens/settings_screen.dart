import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../theme/app_colors.dart';

import 'protection_settings_screen.dart';
import 'account_settings_screen.dart';

import 'about_cleanmind_screen.dart';

class SettingsScreen extends StatelessWidget {
  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

  const SettingsScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _settingsOption(
            icon: Icons.manage_accounts_outlined,
            title: 'Account Settings',
            subtitle:
                'Manage your profile, username, email and account.',
            onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (_) =>
                    AccountSettingsScreen(
                    plan: plan,
                    ),
                ),
            );
            },
          ),

          const SizedBox(height: 14),

          _settingsOption(
            icon: Icons.shield_outlined,
            title: 'Protection Settings',
            subtitle:
                'Manage your protection preferences.',
            onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (_) =>
                    ProtectionSettingsScreen(
                    plan: plan,
                    onPlanChanged:
                        onPlanChanged,
                ),
                ),
            );
            },
          ),

          const SizedBox(height: 14),

          _settingsOption(
            icon: Icons.info_outline,
            title: 'About CleanMind',
            subtitle:
                'Version and application information.',
            onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (_) =>
                    const AboutCleanMindScreen(),
                ),
            );
            },
          ),
        ],
      ),
    );
  }

  Widget _settingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(22),
        child: Padding(
          padding:
              const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration:
                    const BoxDecoration(
                  color: Color(0xFFEAF2FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        color: AppColors
                            .textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        fontSize: 14,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}