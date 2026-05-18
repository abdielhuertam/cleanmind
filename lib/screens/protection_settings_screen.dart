import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import 'custom_blocked_sites_screen.dart';

import 'waiting_period_screen.dart';

import '../services/storage_service.dart';

class ProtectionSettingsScreen
    extends StatefulWidget {
  const ProtectionSettingsScreen({
    super.key,
  });

  @override
  State<ProtectionSettingsScreen>
      createState() =>
          _ProtectionSettingsScreenState();
}

class _ProtectionSettingsScreenState
    extends State<
      ProtectionSettingsScreen
    > {

  bool _protectionActive =
      true;

  @override
  void initState() {
    super.initState();

    _loadProtectionState();
  }

  Future<void>
  _loadProtectionState()
  async {

    final enabled =
        await StorageService
            .loadProtectionEnabled();

    setState(() {
      _protectionActive =
          enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),

          child: Column(
            children: [

              Container(
                height: 42,

                decoration:
                    const BoxDecoration(
                  color:
                      AppColors.primary,

                  borderRadius:
                      BorderRadius.only(
                    bottomLeft:
                        Radius.circular(
                      22,
                    ),

                    bottomRight:
                        Radius.circular(
                      22,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              Row(
                children: [

                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },

                    icon: const Icon(
                      Icons.arrow_back_ios,

                      color:
                          AppColors
                              .primary,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Settings',

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        fontSize: 30,
                        fontWeight:
                            FontWeight.bold,

                        color:
                            AppColors
                                .primary,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 48,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Expanded(
                child: ListView(
                  children: [

                    _sectionTitle(
                      'General',
                    ),

                    _settingsTile(
                      icon:
                          Icons.language,

                      title:
                          'Custom Blocked Sites',

                      subtitle:
                          'Add websites or URLs to block manually.',

                      onTap: () async {

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    CustomBlockedSitesScreen(
                                      protectionActive:
                                          _protectionActive,
                                    ),
                          ),
                        );

                        _loadProtectionState();
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
                    ),

                    _settingsTile(
                      icon:
                          Icons.local_fire_department,

                      title:
                          'Streak Alerts',

                      subtitle:
                          'Celebrate focus milestones and share your progress.',
                    ),

                    const SizedBox(
                      height: 26,
                    ),

                    _sectionTitle(
                      'Advanced',
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
                      height: 20,
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

        trailing: const Icon(
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