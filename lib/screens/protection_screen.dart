import 'dart:async';

import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../state/protection_state.dart';

import '../theme/app_colors.dart';

import 'protection_settings_screen.dart';

import '../services/storage_service.dart';

class ProtectionScreen extends StatefulWidget {
  final PlanState plan;

  final ValueChanged<PlanState> onPlanChanged;

  const ProtectionScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  State<ProtectionScreen> createState() =>
      _ProtectionScreenState();
}

class _ProtectionScreenState
    extends State<ProtectionScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startLifecycleTimer();
  }

  void _startLifecycleTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        if (!mounted) return;

        final protection =
            widget.plan.protection;

        if (protection.status ==
            ProtectionStatus.waitingPeriod) {
          if (protection
              .isDeactivationExpired()) {

            await StorageService
                .saveProtectionEnabled(
              false,
            );

            final updatedPlan =
                widget.plan
                    .unlockSucceeded();

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
    final protection =
        widget.plan.protection;

    final status = protection.status;

    final focusedDays =
        protection
            .getActiveDuration()
            .inDays;

    final isDisabled =
        status ==
            ProtectionStatus
                .protectionDisabled ||
        status ==
            ProtectionStatus.inactive;

    final isWaiting =
        status ==
            ProtectionStatus
                .waitingPeriod;

    final isAwaitingApproval =
        status ==
            ProtectionStatus
                .awaitingApproval;

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

              const SizedBox(height: 24),

              Expanded(
                child: AnimatedSwitcher(
                  duration:
                      const Duration(
                    milliseconds: 250,
                  ),

                  child:
                      isWaiting
                          ? _buildWaitingPeriod()
                          : isAwaitingApproval
                              ? _buildAwaitingApproval()
                              : isDisabled
                                  ? _buildDisabledState()
                                  : _buildActiveState(
                                      focusedDays,
                                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveState(
    int focusedDays,
  ) {
    return Column(
      key: const ValueKey(
        'active_state',
      ),

      children: [
        Container(
          width: double.infinity,

          padding:
              const EdgeInsets.all(
            26,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              30,
            ),

            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            children: [
              const Icon(
                Icons.shield,

                size: 82,

                color:
                    AppColors.primary,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [
                  const Text(
                    'Protection Active',

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,

                      color:
                          AppColors
                              .textPrimary,
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Container(
                    width: 16,
                    height: 16,

                    decoration:
                        const BoxDecoration(
                      color: Colors.green,

                      shape:
                          BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                '$focusedDays',

                style: const TextStyle(
                  fontSize: 62,
                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors.primary,
                ),
              ),

              const Text(
                'days focused',

                style: TextStyle(
                  fontSize: 22,

                  color:
                      AppColors
                          .textSecondary,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) =>
                        const ProtectionSettingsScreen(),
              ),
            );
          },

          child: Container(
            width: double.infinity,

            padding:
                const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 18,
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
              children: const [
                Icon(
                  Icons.settings,

                  size: 34,

                  color:
                      AppColors.primary,
                ),

                SizedBox(width: 18),

                Expanded(
                  child: Text(
                    'Protection Settings',

                    style: TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,

                      color:
                          AppColors
                              .textPrimary,
                    ),
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios,

                  color:
                      AppColors.primary,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        ElevatedButton(
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.primary,

            foregroundColor:
                Colors.white,

            minimumSize:
                const Size(
              double.infinity,
              62,
            ),

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
              '/unlock-methods',
            );

            if (!mounted) return;

            setState(() {});
          },

          child: const Text(
            'Request Unlock',

            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaitingPeriod() {
    final remaining =
        widget.plan.protection
            .getRemainingDeactivationTime();

    return Column(
      key: const ValueKey(
        'waiting_state',
      ),

      children: [
        Container(
          width: double.infinity,

          padding:
              const EdgeInsets.symmetric(
            horizontal: 26,
            vertical: 24,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              30,
            ),

            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            children: [
              const Icon(
                Icons.schedule,

                size: 72,

                color:
                    AppColors.primary,
              ),

              const SizedBox(height: 20),

              const Text(
                'Waiting Period Active',

                textAlign:
                    TextAlign.center,

                style: TextStyle(
                  fontSize: 26,
                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors
                          .textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Protection is still active during the countdown.',

                textAlign:
                    TextAlign.center,

                style: TextStyle(
                  fontSize: 17,
                  height: 1.35,

                  color:
                      AppColors
                          .textSecondary,
                ),
              ),

              const SizedBox(height: 28),

              Text(
                remaining == null
                    ? '--:--:--'
                    : _formatDuration(
                        remaining,
                      ),

                style: const TextStyle(
                  fontSize: 46,
                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,

                height: 56,

                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.danger,

                    foregroundColor:
                        Colors.white,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),

                  onPressed: () async {

                    await StorageService
                        .saveProtectionEnabled(
                      true,
                    );

                    final updatedPlan =
                        widget.plan
                            .cancelDeactivation();

                    widget
                        .onPlanChanged(
                      updatedPlan,
                    );
                  },

                  child: const Text(
                    'Cancel Deactivation',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) =>
                        const ProtectionSettingsScreen(),
              ),
            );
          },

          child: Container(
            width: double.infinity,

            padding:
                const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 18,
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
              children: const [
                Icon(
                  Icons.settings,

                  size: 34,

                  color:
                      AppColors.primary,
                ),

                SizedBox(width: 18),

                Expanded(
                  child: Text(
                    'Protection Settings',

                    style: TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,

                      color:
                          AppColors
                              .textPrimary,
                    ),
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios,

                  color:
                      AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAwaitingApproval() {
    return const SizedBox();
  }

  Widget _buildDisabledState() {

    StorageService
        .saveProtectionEnabled(
      false,
    );
    
    return Column(
      key: const ValueKey(
        'disabled_state',
      ),

      children: [
        Container(
          width: double.infinity,

          padding:
              const EdgeInsets.all(
            26,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              30,
            ),

            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            children: [
              const Icon(
                Icons.shield_outlined,

                size: 82,

                color: Colors.red,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [
                  const Text(
                    'Protection Disabled',

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,

                      color:
                          AppColors
                              .textPrimary,
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Container(
                    width: 16,
                    height: 16,

                    decoration:
                        const BoxDecoration(
                      color: Colors.red,

                      shape:
                          BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Protection is currently turned off.',

                textAlign:
                    TextAlign.center,

                style: TextStyle(
                  fontSize: 18,
                  color:
                      AppColors
                          .textSecondary,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) =>
                        const ProtectionSettingsScreen(),
              ),
            );
          },

          child: Container(
            width: double.infinity,

            padding:
                const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 18,
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
              children: const [
                Icon(
                  Icons.settings,

                  size: 34,

                  color:
                      AppColors.primary,
                ),

                SizedBox(width: 18),

                Expanded(
                  child: Text(
                    'Protection Settings',

                    style: TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,

                      color:
                          AppColors
                              .textPrimary,
                    ),
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios,

                  color:
                      AppColors.primary,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        ElevatedButton(
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                Colors.green,

            foregroundColor:
                Colors.white,

            minimumSize:
                const Size(
              double.infinity,
              62,
            ),

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                22,
              ),
            ),
          ),

          onPressed: () async {

            await StorageService
                .saveProtectionEnabled(
              true,
            );

            final updatedPlan =
                widget.plan
                    .manualReactivate();

            widget.onPlanChanged(
              updatedPlan,
            );
          },

          child: const Text(
            'Activate Protection',

            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}