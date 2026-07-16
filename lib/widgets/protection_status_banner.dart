import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProtectionStatusBanner
    extends StatelessWidget {

  final bool isActive;
  final int focusedDays;
  final String? subtitle;
  final String title;

  const ProtectionStatusBanner({
    super.key,
    required this.isActive,
    required this.focusedDays,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Icon(
            Icons.shield,

            size: 42,

            color: isActive
                ? AppColors.primary
                : Colors.red,
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Row(
                  children: [
                    Text(
                      title,

                      style:
                          const TextStyle(
                        fontSize: 18,
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
                        color: isActive
                            ? Colors.green
                            : Colors.red,

                        shape:
                            BoxShape.circle,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle ??
                      '$focusedDays days focused',

                  style: const TextStyle(
                    fontSize: 16,
                    color:
                        AppColors
                            .textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}