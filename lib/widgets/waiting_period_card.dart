import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'primary_button.dart';

class WaitingPeriodCard extends StatelessWidget {
  final Duration? remaining;
  final VoidCallback onCancel;

  const WaitingPeriodCard({
    super.key,
    required this.remaining,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
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
              color:
                  AppColors.primary.withOpacity(0.10),
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
                : '${remaining!.inHours.toString().padLeft(2, '0')}:'
                    '${(remaining!.inMinutes % 60).toString().padLeft(2, '0')}:'
                    '${(remaining!.inSeconds % 60).toString().padLeft(2, '0')}',
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
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}