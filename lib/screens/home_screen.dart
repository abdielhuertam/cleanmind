import 'dart:async';

import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../state/protection_state.dart';

import '../theme/app_colors.dart';

import '../widgets/protection_status_banner.dart';
import '../widgets/request_pending_banner.dart';

import 'main_shell_screen.dart';
import 'pending_requests_screen.dart';

import '../widgets/streak_circle_card.dart';

class HomeScreen extends StatefulWidget {
  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

  const HomeScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {

        if (!mounted) return;

        final refreshedPlan =
            widget.plan
                .refreshLifecycle();

        if (refreshedPlan !=
            widget.plan) {

          widget.onPlanChanged(
            refreshedPlan,
          );
        }

        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(
    Duration duration,
  ) {
    final hours =
        duration.inHours
            .toString()
            .padLeft(2, '0');

    final minutes =
        (duration.inMinutes % 60)
            .toString()
            .padLeft(2, '0');

    final seconds =
        (duration.inSeconds % 60)
            .toString()
            .padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }
  
  String _formatRemainingTime(
    Duration duration,
  ) {

    final days =
        duration.inDays;

    final hours =
        duration.inHours % 24;

    final minutes =
        duration.inMinutes % 60;

    final seconds =
        duration.inSeconds % 60;

    if (days > 0) {
      return '${days}d ${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
    }

    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
  }
  @override
  Widget build(BuildContext context) {

    final status =
        widget.plan.protection.status;

    final isProtectionActive =
        status.name !=
            'protectionDisabled' &&
        status.name != 'inactive';

    final focusedDays =
        widget.plan.streakDays;

    final hasPendingRequest =
        widget.plan.unlockRequest
            .isPending;

    return SingleChildScrollView(
      child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

          Container(
            width: double.infinity,

            margin: const EdgeInsets.only(
              bottom: 12,
            ),

            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                24,
              ),

              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: Row(
              children: [

                Expanded(
                  child: Column(
                    children: [

                      Text(
                        '${widget.plan.xp}',
                        style:
                            const TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      const Text(
                        'XP',
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [

                      Text(
                        '${widget.plan.level}',
                        style:
                            const TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      const Text(
                        'Level',
                      ),
                    ],
                  ),
                ),

                const Expanded(
                  child: Column(
                    children: [

                      Text(
                        '--',
                        style:
                            TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        'Top',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {

              MainShellScreen.of(
                context,
              )?.changeTab(1);
            },
            child: ProtectionStatusBanner(
              isActive: isProtectionActive,
              focusedDays: focusedDays,

              title: !isProtectionActive
                  ? 'Protection Disabled'
                  : widget.plan.protection.mode ==
                          ProtectionMode.partial
                      ? 'Partial Protection'
                      : 'Permanent Protection',

              subtitle:
                  widget.plan.protection.mode ==
                              ProtectionMode.partial &&
                          widget.plan.protection.status ==
                              ProtectionStatus.active
                      ? '${_formatRemainingTime(
                          widget.plan.protection
                                  .getRemainingPartialTime() ??
                              Duration.zero,
                        )} remaining'
                      : null,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 205,
            child: StreakCircleCard(
              streakDays: widget.plan.streakDays,
            ),
          ),

          if (hasPendingRequest)
            RequestPendingBanner(
              remaining:
                  widget
                      .plan
                      .unlockRequest
                      .getRemainingTime(),

              onCancel: () {

                final updatedPlan =
                    widget.plan
                        .cancelPushRequest();

                widget.onPlanChanged(
                  updatedPlan,
                );
              },
            ),

          if (!isProtectionActive)
            Column(
              children: [

                const SizedBox(
                  height: 2,
                ),

                SizedBox(
                  width: double.infinity,

                  height: 60,

                  child: ElevatedButton(
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          Colors.green,

                      foregroundColor:
                          Colors.white,

                      elevation: 4,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          22,
                        ),
                      ),
                    ),

                    onPressed: () async {

                      await Navigator.pushNamed(
                        context,
                        '/protection-mode',
                      );

                      if (!mounted) return;

                      if (widget.plan.protection.status !=
                              ProtectionStatus.inactive &&
                          widget.plan.protection.status !=
                              ProtectionStatus.protectionDisabled) {
                        MainShellScreen.of(context)?.changeTab(1);
                      }
                    },

                    child: const Text(
                      'Activate Protection',

                      style:
                          TextStyle(
                        fontSize: 20,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Row(
              children: [

                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey.shade300,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Text(
                    'ACCOUNTABILITY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.grey,
                    ),
                  ),
                ),

                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            GestureDetector(
            onTap: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder:
                      (_) =>
                          PendingRequestsScreen(
                            plan:
                                widget.plan,

                            onPlanChanged:
                                widget
                                    .onPlanChanged,
                          ),
                ),
              );
            },

            child: Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),

              decoration:
                  BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  26,
                ),

                boxShadow: const [
                  BoxShadow(
                    color:
                        Colors.black12,

                    blurRadius: 8,

                    offset:
                        Offset(0, 4),
                  ),
                ],
              ),

              child: Row(
                children: [

                  Icon(
                    Icons.touch_app,

                    size: 28,

                    color:
                        AppColors
                            .primary,
                  ),

                  SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      mainAxisSize:
                          MainAxisSize.min,

                      children: [

                        const Text(
                          'Pending Requests',

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,

                            color:
                                AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          widget.plan.unlockRequest
                                  .isPending
                              ? '1 pending request'
                              : 'No pending requests',

                          style: const TextStyle(
                            fontSize: 14,
                            color:
                                AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons
                        .arrow_forward_ios,

                    color:
                        AppColors
                            .primary,
                  ),
                ],
              ),
            ),
          ),

              const SizedBox(height: 24),
        ],
      ),
    );
  }
}
