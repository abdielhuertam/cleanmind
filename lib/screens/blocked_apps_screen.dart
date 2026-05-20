import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../services/storage_service.dart';

import '../state/plan_state.dart';
import '../state/protection_state.dart';

class BlockedAppsScreen
    extends StatefulWidget {
  final PlanState plan;

  const BlockedAppsScreen({
    super.key,
    required this.plan,
  });

  @override
  State<BlockedAppsScreen>
      createState() =>
          _BlockedAppsScreenState();
}

class _BlockedAppsScreenState
    extends State<
      BlockedAppsScreen
    > {

  final List<String>
  _availableApps = [
    'Instagram',
    'TikTok',
    'YouTube',
    'Reddit',
    'X',
    'Chrome',
    'Safari',
    'Discord',
    'Telegram',
    'Facebook',
  ];

  List<String>
  _blockedApps = [];

  @override
  void initState() {
    super.initState();

    _loadBlockedApps();
  }

  Future<void>
  _loadBlockedApps() async {

    final loaded =
        await StorageService
            .loadBlockedApps();

    if (!mounted) return;

    setState(() {
      _blockedApps = loaded;
    });
  }

  bool get _protectionActive {

    final status =
        widget.plan.protection.status;

    return status !=
            ProtectionStatus
                .protectionDisabled &&
        status !=
            ProtectionStatus
                .inactive;
  }

  Future<void>
  _toggleApp(
    String app,
  ) async {

    if (_protectionActive &&
        _blockedApps.contains(
          app,
        )) {
      return;
    }

    setState(() {

      if (_blockedApps.contains(
        app,
      )) {

        _blockedApps.remove(
          app,
        );

      } else {

        _blockedApps.add(
          app,
        );
      }
    });

    await StorageService
        .saveBlockedApps(
      _blockedApps,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    final protectionActive =
        _protectionActive;

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
          'Blocked Apps',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),

        child: Column(
          children: [

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
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
                    offset: Offset(
                      0,
                      4,
                    ),
                  ),
                ],
              ),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Icon(
                    protectionActive
                        ? Icons.lock
                        : Icons.apps,

                    color:
                        AppColors
                            .primary,
                  ),

                  const SizedBox(
                    width: 14,
                  ),

                  Expanded(
                    child: Text(
                      protectionActive
                          ? 'You can add new blocked apps while protection is active, but protected apps cannot be removed.'
                          : 'Select apps you want CleanMind to help you avoid.',

                      style:
                          const TextStyle(
                        fontSize: 15,
                        height: 1.4,

                        color:
                            AppColors
                                .textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            Expanded(
              child: ListView.builder(
                itemCount:
                    _availableApps.length,

                itemBuilder: (
                  context,
                  index,
                ) {

                  final app =
                      _availableApps[
                          index];

                  final isBlocked =
                      _blockedApps
                          .contains(
                    app,
                  );

                  return Container(
                    margin:
                        const EdgeInsets.only(
                      bottom: 14,
                    ),

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),

                      boxShadow: const [
                        BoxShadow(
                          color:
                              Colors.black12,

                          blurRadius: 8,

                          offset:
                              Offset(
                            0,
                            4,
                          ),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [

                        Container(
                          width: 48,
                          height: 48,

                          decoration:
                              BoxDecoration(
                            color:
                                AppColors
                                    .primary
                                    .withOpacity(
                              0.1,
                            ),

                            shape:
                                BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.apps,

                            color:
                                AppColors
                                    .primary,
                          ),
                        ),

                        const SizedBox(
                          width: 16,
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                app,

                                style:
                                    const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.w600,

                                  color:
                                      AppColors
                                          .textPrimary,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                isBlocked
                                    ? 'Protected app'
                                    : 'Not protected',

                                style:
                                    TextStyle(
                                  fontSize: 14,

                                  color:
                                      isBlocked
                                          ? AppColors.primary
                                          : AppColors
                                              .textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Switch(
                          value:
                              isBlocked,

                          activeColor:
                              AppColors
                                  .primary,

                          onChanged:
                              (_) async {
                            await _toggleApp(
                              app,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}