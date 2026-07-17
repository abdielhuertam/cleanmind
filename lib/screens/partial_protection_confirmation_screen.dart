import 'package:flutter/material.dart';

import '../services/protection_service.dart';
import '../state/plan_state.dart';
import '../theme/app_colors.dart';

import '../widgets/protection_status_overlay.dart';

class PartialProtectionConfirmationScreen extends StatelessWidget {
  final PlanState plan;
  final ValueChanged<PlanState> onPlanChanged;
  final Duration selectedDuration;

  const PartialProtectionConfirmationScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
    required this.selectedDuration,
  });

  String get durationText {
    final roundedMinutes = (selectedDuration.inSeconds / 60).ceil();

    if (roundedMinutes < 60) {
      return '$roundedMinutes min';
    }

    final hours = selectedDuration.inHours;
    final remaining = selectedDuration.inMinutes % 60;

    if (hours < 24) {
      return '$hours h $remaining m';
    }

    final days = selectedDuration.inDays;

    return '$days day(s)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Confirm Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.eco,
              size: 52,
              color: AppColors.success,
            ),

            const SizedBox(height: 16),

            const Text(
              'Ready to Stay Focused?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Your focus session is configured and ready to begin.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Focus Session',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Duration',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    durationText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Protection will start when you tap "Start Focus Session" and will automatically end after the selected duration.',
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
              ),
              onPressed: () async {
                final expiresAt =
                    DateTime.now().add(selectedDuration);

                final updatedPlan =
                    await ProtectionService.activatePartialProtection(
                  plan: plan,
                  expiresAt: expiresAt,
                );

                onPlanChanged(updatedPlan);

                await ProtectionStatusOverlay.showActivated(
                  context,
                );

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);

              },
              child: const Text(
                'Start Focus Session',
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}