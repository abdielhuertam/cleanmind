import 'dart:async';

import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../theme/app_colors.dart';

import '../widgets/protection_status_banner.dart';
import '../widgets/request_pending_banner.dart';

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

        final request =
            widget.plan.unlockRequest;

        if (request.isPending) {
          if (request.isExpired()) {
            final updatedPlan =
                widget.plan
                    .expirePushRequest();

            widget.onPlanChanged(
              updatedPlan,
            );
          } else {
            setState(() {});
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            crossAxisAlignment:
                CrossAxisAlignment.start,

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
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [
                  const Text(
                    'Clean Mind',

                    style: TextStyle(
                      fontSize: 34,
                      fontWeight:
                          FontWeight.bold,

                      color:
                          AppColors.primary,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  PendingRequestsScreen(
                                    plan:
                                        widget
                                            .plan,

                                    onPlanChanged:
                                        widget
                                            .onPlanChanged,
                                  ),
                        ),
                      );
                    },

                    child: Stack(
                      children: [
                        const Icon(
                          Icons.notifications,

                          size: 34,

                          color:
                              AppColors
                                  .primary,
                        ),

                        Positioned(
                          right: 0,

                          child: Container(
                            width: 14,
                            height: 14,

                            decoration:
                                BoxDecoration(
                              color:
                                  hasPendingRequest
                                      ? Colors.red
                                      : Colors.grey,

                              shape:
                                  BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              ProtectionStatusBanner(
                isActive:
                    isProtectionActive,

                focusedDays:
                    focusedDays,
              ),

              const SizedBox(height: 24),

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

                    widget
                        .onPlanChanged(
                      updatedPlan,
                    );
                  },
                ),

              if (!isProtectionActive)
                Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),

                    SizedBox(
                      width: double.infinity,

                      height: 64,

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
                            fontSize: 22,
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
            ],
          ),
        ),
      ),
    );
  }
}