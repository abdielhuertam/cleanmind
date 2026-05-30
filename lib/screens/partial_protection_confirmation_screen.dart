import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../state/plan_state.dart';

class PartialProtectionConfirmationScreen
    extends StatelessWidget {

  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

  final Duration selectedDuration;

  const PartialProtectionConfirmationScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
    required this.selectedDuration,
  });

    Duration get duration =>
        selectedDuration;

    String get durationText {

    final roundedMinutes =
        (duration.inSeconds / 60)
            .ceil();

    if (roundedMinutes < 60) {
        return '$roundedMinutes min';
    }

    final hours =
        duration.inHours;

    final remaining =
        duration.inMinutes % 60;

    if (hours < 24) {
        return '$hours h $remaining m';
    }

    final days =
        duration.inDays;

    return '$days days';
    }

    String formatDateTime() {

    final actualExpiresAt =
        DateTime.now().add(
        selectedDuration,
    );

    final hour =
        actualExpiresAt.hour > 12
            ? actualExpiresAt.hour - 12
            : actualExpiresAt.hour == 0
                ? 12
                : actualExpiresAt.hour;

    final ampm =
        actualExpiresAt.hour >= 12
            ? 'PM'
            : 'AM';

    return '${actualExpiresAt.day}/${actualExpiresAt.month}/${actualExpiresAt.year} • $hour:${actualExpiresAt.minute.toString().padLeft(2, '0')} $ampm';
    }

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
        title: const Text(
          'Confirm Session',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [

            const SizedBox(
              height: 20,
            ),

            const Icon(
              Icons.eco,
              size: 52,
              color:
                  AppColors.success,
            ),

            const SizedBox(
              height: 16,
            ),

            const Text(
              'Ready to Stay Focused?',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              'Your focus session is configured and ready to begin.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),

            const SizedBox(
              height: 28,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                18,
              ),

              decoration:
                  BoxDecoration(
                color:
                    Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),

                boxShadow: const [
                  BoxShadow(
                    color:
                        Colors.black12,
                    blurRadius: 6,
                    offset:
                        Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Focus Session',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  const Text(
                    'Duration',
                    style: TextStyle(
                      color:
                          Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    durationText,
                    style:
                        const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  const Text(
                    'Ends',
                    style: TextStyle(
                      color:
                          Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    formatDateTime(),
                    style:
                        const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                16,
              ),

              decoration:
                  BoxDecoration(
                color:
                    Colors.green
                        .shade50,

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child: const Text(
                'Protection will automatically end when your selected time is reached.',
                textAlign:
                    TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.success,
                foregroundColor:
                    Colors.white,
                minimumSize:
                    const Size(
                  double.infinity,
                  56,
                ),
              ),

              onPressed: () {

                final actualExpiresAt =
                    DateTime.now().add(
                selectedDuration,
                );

                final updatedPlan =
                    plan.activatePartialProtection(
                actualExpiresAt,
                );

                onPlanChanged(
                  updatedPlan,
                );

                Navigator.popUntil(
                  context,
                  (route) =>
                      route.isFirst,
                );
              },

              child: const Text(
                'Start Focus Session',
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },

              child: const Text(
                'Go Back',
              ),
            ),
          ],
        ),
      ),
    );
  }
}