import 'dart:async';

import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../state/protection_state.dart';

import '../theme/app_colors.dart';

class ProtectionScreen extends StatefulWidget {
  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

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

  String _formatCountdown(
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

  String _formatFocusTime(
    Duration duration,
  ) {
    final hours =
        (duration.inHours % 24)
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
    final hours =
        duration.inHours;

    final minutes =
        duration.inMinutes % 60;

    final seconds =
        duration.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final protection =
        widget.plan.protection;

    final status =
        protection.status;

    final focusedDays =
        protection
            .getActiveDuration()
            .inDays;

    final isDisabled =
        status ==
            ProtectionStatus
                .protectionDisabled ||
        status ==
            ProtectionStatus
                .inactive;

    return SingleChildScrollView(
      child: Column(
        children: [
          AnimatedSwitcher(
            duration:
                const Duration(
              milliseconds: 250,
            ),

            child: isDisabled
                ? _buildDisabledState()
                : _buildActiveState(
                    focusedDays,
                  ),
          ),

          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveState(
    int focusedDays,
  ) {
      final protection =
          widget.plan.protection;

      final isPartial =
          protection.mode ==
              ProtectionMode.partial;

      final remaining =
          protection
              .getRemainingPartialTime();
    return Column(
      children: [
        _buildMainCard(
          icon: Icons.shield,

          iconColor:
              AppColors.primary,

          title: isPartial
              ? 'Partial Protection'
              : 'Permanent Protection',

          dotColor:
              Colors.green,

          content: Column(
            children: [
              Text(
                isPartial
                    ? _formatRemainingTime(
                        remaining ??
                            Duration.zero,
                      )
                    : '$focusedDays',

                style: const TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(
                height: 4,
              ),

              Text(
                isPartial
                    ? 'time remaining'
                    : 'days focused',

                style: TextStyle(
                  fontSize: 15,

                  color:
                      AppColors
                          .textSecondary,
                ),
              ),

              const SizedBox(
                height: 14,
              ),

if (isPartial &&
    protection.expiresAt != null)
  Container(
    padding:
        const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 8,
    ),

    decoration: BoxDecoration(
      color:
          AppColors.primary
              .withOpacity(
        0.08,
      ),

      borderRadius:
          BorderRadius.circular(
        18,
      ),
    ),

    child: Text(
      'Ends ${protection.expiresAt!.day}/${protection.expiresAt!.month}/${protection.expiresAt!.year}',
      style:
          const TextStyle(
        fontSize: 16,
        fontWeight:
            FontWeight.w600,
        color:
            AppColors.primary,
      ),
    ),
  )
else
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color:
                      AppColors.primary
                          .withOpacity(
                    0.08,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),

                child: Text(
                  _formatFocusTime(
                    widget.plan.protection
                        .getActiveDuration(),
                  ),

                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: 1.1,
                    color:
                        AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 16,
        ),
        SizedBox(
          width: double.infinity,

          height: 52,

          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primary,

              foregroundColor:
                  Colors.white,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
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
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisabledState() {
    return Column(
      children: [
        _buildMainCard(
          icon:
              Icons.shield_outlined,

          iconColor:
              Colors.red,

          title:
              'Protection Disabled',

          dotColor:
              Colors.red,

          content: const Padding(
            padding:
                EdgeInsets.only(
              top: 8,
            ),

            child: Text(
              'Protection is currently turned off.',

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                fontSize: 15,

                color:
                    AppColors
                        .textSecondary,
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        SizedBox(
          width: double.infinity,

          height: 52,

          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.green,

              foregroundColor:
                  Colors.white,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
            ),

            onPressed: () {
              Navigator.pushNamed(
                context,
                '/protection-mode',
              );
            },

            child: const Text(
              'Activate Protection',

              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainCard({
  required IconData icon,
  required Color iconColor,
  required String title,
  required Color dotColor,
  required Widget content,
}) {
  return Container(
    width: double.infinity,

    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 16,
    ),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius: BorderRadius.circular(
        26,
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
        Icon(
          icon,
          size: 38,
          color: iconColor,
        ),

        const SizedBox(
          height: 10,
        ),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Text(
              title,

              style: const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,

                color:
                    AppColors
                        .textPrimary,
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            Container(
              width: 12,
              height: 12,

              decoration:
                  BoxDecoration(
                color: dotColor,

                shape:
                    BoxShape.circle,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 14,
        ),

        content,
      ],
    ),
  );
}
}