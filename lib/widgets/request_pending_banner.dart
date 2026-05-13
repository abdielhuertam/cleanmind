import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RequestPendingBanner
    extends StatelessWidget {
  final Duration? remaining;
  final VoidCallback onCancel;

  const RequestPendingBanner({
    super.key,
    required this.remaining,
    required this.onCancel,
  });

  String _formatTime(Duration? duration) {
    if (duration == null) {
      return '--:--';
    }

    final minutes =
        duration.inMinutes
            .remainder(60)
            .toString()
            .padLeft(2, '0');

    final seconds =
        duration.inSeconds
            .remainder(60)
            .toString()
            .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.orange.shade300,
        ),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.notifications_active,
            color: Colors.orange,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Approval Pending',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatTime(remaining),
                  style: const TextStyle(
                    fontSize: 15,
                    color:
                        AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: onCancel,
            child: const Text(
              'Cancel',
            ),
          ),
        ],
      ),
    );
  }
}