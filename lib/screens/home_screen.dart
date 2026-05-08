import 'dart:async';
import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../state/protection_state.dart';

import '../theme/app_colors.dart';

import '../widgets/primary_button.dart';
import '../widgets/status_card.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  final PlanState plan;
  final ValueChanged<PlanState> onPlanChanged;

  const HomeScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

        final protection = widget.plan.protection;

        if (protection.status ==
            ProtectionStatus.waitingPeriod) {
          if (protection.isDeactivationExpired()) {
            final updatedPlan =
                widget.plan.unlockSucceeded();

            widget.onPlanChanged(updatedPlan);
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
    final protection = widget.plan.protection;



    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [

            // TOP BAR
            Container(
              height: 42,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: ListView(
                  padding: const EdgeInsets.only(
                    bottom: 40,
                    ),
                  children: [

                    // HEADER
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Clean Mind',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),

                        Stack(
                          children: [
                            const Icon(
                              Icons.notifications,
                              size: 34,
                              color: AppColors.primary,
                            ),

                            Positioned(
                              right: 0,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    if (protection.status == ProtectionStatus.waitingPeriod)
                      _buildActionArea()
                    else ...[
                      StatusCard(
                        isActive:
                            protection.status == ProtectionStatus.active ||
                            protection.status == ProtectionStatus.waitingPeriod,
                        streakDays:
                            protection.getActiveDuration().inDays,
                      ),

                      const SizedBox(height: 28),

                      _buildActionArea(),
                    ],
                  ],
                ),
              ),
            ),

            BottomNavigation(
              isPro: widget.plan.isPro,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionArea() {
    final status = widget.plan.protection.status;

    switch (status) {

      case ProtectionStatus.active:

        return SingleChildScrollView(
          child: Column(
            children: [

              PrimaryButton(
                text: 'Request Unlock',
                onPressed: () {},
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: const Color(0xFFE57373),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: () {
                    _showDeactivationDialog(context);
                  },
                  child: const Text(
                    'Deactivate Protection',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case ProtectionStatus.waitingPeriod:

        final remaining =
            widget.plan.protection
                .getRemainingDeactivationTime();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                width: 88,
                height: 88,

                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.schedule,
                  size: 42,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Take a moment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Pause before disabling protection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                remaining == null
                    ? '--:--:--'
                    : '${remaining.inHours.toString().padLeft(2, '0')}:'
                      '${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:'
                      '${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',

                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: 'Cancel Deactivation',
                onPressed: () {

                  final updatedPlan =
                      widget.plan.cancelDeactivation();

                  widget.onPlanChanged(updatedPlan);
                },
              ),
            ],
          ),
        );
        case ProtectionStatus.awaitingApproval:

          return SingleChildScrollView(
            child: Column(
              children: [

                const Icon(
                  Icons.lock_clock,
                  size: 70,
                  color: AppColors.primary,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Waiting for Approval',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Your support contact must approve this request.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                PrimaryButton(
                  text: 'Cancel Request',
                  onPressed: () {

                    final updatedPlan =
                        widget.plan.cancelDeactivation();

                    widget.onPlanChanged(updatedPlan);
                  },
                ),
              ],
            ),
          );
      case ProtectionStatus.protectionDisabled:
      case ProtectionStatus.inactive:

        return SingleChildScrollView(
          child: Column(
            children: [

              PrimaryButton(
                text: 'Activate Protection',
                onPressed: () {
                  final updatedPlan =
                      widget.plan.manualReactivate();

                  widget.onPlanChanged(updatedPlan);
                },
              ),
            ],
          ),
        );
    }
  }

  void _showDeactivationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Confirm Deactivation',
        ),
        content: Text(
          !widget.plan.isPro
              ? 'Protection will be disabled after the waiting period.'
              : widget.plan.hasSupport
                  ? 'A support approval request will be sent.'
                  : 'Protection will be disabled after the configured waiting period.',
        ),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),

          TextButton(
            onPressed: () {

              Navigator.pop(context);

              final updatedPlan =
                  widget.plan.requestDeactivation();

              widget.onPlanChanged(updatedPlan);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}