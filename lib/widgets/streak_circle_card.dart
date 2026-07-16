import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StreakCircleCard extends StatelessWidget {
  final int streakDays;

  const StreakCircleCard({
    super.key,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(
        bottom: 20,
      ),

      padding: const EdgeInsets.symmetric(
        vertical: 12,
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

      child: Column(
        children: [

          SizedBox(
            width: 110,
            height: 110,

            child: Stack(
              alignment:
                  Alignment.center,

              children: [

                SizedBox(
                  width: 140,
                  height: 140,

                  child:
                      CircularProgressIndicator(
                    value: 1,

                    strokeWidth: 8,

                    color:
                        AppColors.primary,

                    backgroundColor:
                        Colors.grey.shade200,
                  ),
                ),

                Column(
                  mainAxisSize:
                      MainAxisSize.min,

                  children: [

                    Text(
                      '$streakDays',

                      style:
                          const TextStyle(
                        fontSize: 32,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const Text(
                      'DAYS',

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 2,
          ),

          const Text(
            'Días enfocado',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 2),

          const Text(
            '¡Sigue así!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}