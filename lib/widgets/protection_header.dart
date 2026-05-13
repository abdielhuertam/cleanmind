import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProtectionHeader extends StatelessWidget {
  const ProtectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}