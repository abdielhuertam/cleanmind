import 'dart:async';

import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../state/protection_state.dart';

import '../theme/app_colors.dart';

import '../widgets/protection_status_banner.dart';
import '../widgets/request_pending_banner.dart';

import 'main_shell_screen.dart';
import 'pending_requests_screen.dart';

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

  @override
  Widget build(BuildContext context) {

    final status =
        widget.plan.protection.status;

    final isProtectionActive =
        status.name !=
            'protectionDisabled' &&
        status.name != 'inactive';

    final focusedDays =
        widget.plan.protection
            .getActiveDuration()
            .inDays;

    final hasPendingRequest =
        widget.plan.unlockRequest
            .isPending;

    final waitingPeriodActive =
        status ==
            ProtectionStatus
                .waitingPeriod;

    final remainingWaitingTime =
        widget.plan.protection
            .getRemainingDeactivationTime();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          if (waitingPeriodActive &&
              remainingWaitingTime !=
                  null)
            Container(
              width: double.infinity,

              margin:
                  const EdgeInsets.only(
                bottom: 22,
              ),

              padding:
                  const EdgeInsets.all(
                20,
              ),

              decoration:
                  BoxDecoration(
                color:
                    Colors.orange
                        .shade50,

                borderRadius:
                    BorderRadius.circular(
                  26,
                ),

                border: Border.all(
                  color:
                      Colors.orange
                          .shade300,
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

                  Container(
                    width: 56,
                    height: 56,

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.orange
                              .shade100,

                      shape:
                          BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.hourglass_bottom,

                      color:
                          Colors.orange
                              .shade700,

                      size: 30,
                    ),
                  ),

                  const SizedBox(
                    width: 18,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(
                          'Waiting Period Active',

                          style:
                              TextStyle(
                            fontSize: 18,

                            fontWeight:
                                FontWeight
                                    .bold,

                            color:
                                Colors.orange
                                    .shade800,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Text(
                          '${_formatDuration(remainingWaitingTime)} remaining',

                          style:
                              TextStyle(
                            fontSize: 16,

                            fontWeight:
                                FontWeight
                                    .w600,

                            color:
                                Colors.orange
                                    .shade700,
                          ),
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
              isActive:
                  isProtectionActive,

              focusedDays:
                  focusedDays,
            ),
          ),

          const SizedBox(height: 22),

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
                  height: 22,
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

                    onPressed: () {

                      final updatedPlan =
                          widget.plan
                              .manualReactivate();

                      widget
                          .onPlanChanged(
                        updatedPlan,
                      );
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

          const SizedBox(height: 22),

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
                  const EdgeInsets.all(
                22,
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
                children: const [

                  Icon(
                    Icons.touch_app,

                    size: 42,

                    color:
                        AppColors
                            .primary,
                  ),

                  SizedBox(width: 18),

                  Expanded(
                    child: Text(
                      'Pending Requests',

                      style:
                          TextStyle(
                        fontSize: 22,

                        fontWeight:
                            FontWeight
                                .bold,

                        color:
                            AppColors
                                .textPrimary,
                      ),
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