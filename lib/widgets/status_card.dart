import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusCard extends StatelessWidget {
  final bool isActive;
  final int streakDays;

  const StatusCard({
    super.key,
    required this.isActive,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {

    final statusColor =
        isActive
            ? AppColors.success
            : AppColors.danger;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 22,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(30),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [

          // SHIELD
          Container(
            width: 96,
            height: 96,

            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,

              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: const Icon(
              Icons.shield,
              size: 52,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 18),

          // STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                isActive
                    ? 'Protection Active'
                    : 'Protection Disabled',

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(width: 10),

              Container(
                width: 14,
                height: 14,

                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // COUNTER
          RichText(
            text: TextSpan(
              children: [

                TextSpan(
                  text: '$streakDays',

                  style: const TextStyle(
                    fontSize: 58,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                const TextSpan(
                  text: ' days',

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'focused',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}