import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'primary_button.dart';

class ApprovalPendingCard extends StatelessWidget {
  final VoidCallback onCancel;

  const ApprovalPendingCard({
    super.key,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
          onPressed: onCancel,
        ),
      ],
    );
  }
}