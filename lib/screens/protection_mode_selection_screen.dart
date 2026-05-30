import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../theme/app_colors.dart';

import 'permanent_protection_confirmation_screen.dart';
import 'partial_duration_selection_screen.dart';

class ProtectionModeSelectionScreen
    extends StatelessWidget {

  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

  const ProtectionModeSelectionScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

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
          'Choose Protection',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(
          24,
        ),

        child: Column(
          children: [

            _modeCard(
              context,

              icon: Icons.shield,

              title:
                  'Permanent Protection',

              description: const [
                'Full XP rewards',
                'Earn medals',
                'Increase your ranking',
              ],

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder:
                        (_) =>
                            PermanentProtectionConfirmationScreen(
                              plan: plan,
                              onPlanChanged:
                                  onPlanChanged,
                            ),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 16,
            ),

            _modeCard(
              context,

              icon: Icons.schedule,

              title:
                  'Partial Protection',

              description: const [
                'Focus session',
                'Reduced XP',
                'Auto deactivation',
              ],

              isProFeature: true,

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder:
                        (_) =>
                          PartialDurationSelectionScreen(
                            plan: plan,
                            onPlanChanged:
                                onPlanChanged,
                          )
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<String> description,
    required VoidCallback onTap,
    bool isProFeature = false,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding:
            const EdgeInsets.all(
          18,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            24,
          ),

          boxShadow: const [
            BoxShadow(
              color:
                  Colors.black12,

              blurRadius: 8,

              offset:
                  Offset(0, 4),
            ),
          ],
        ),

        child: Stack(
          children: [

            if (isProFeature)
              Positioned(
                top: 0,
                right: 0,

                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.primary,

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: const Text(
                    'PRO',

                    style: TextStyle(
                      color:
                          Colors.white,

                      fontSize: 11,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

            Row(
              children: [

                Icon(
                  icon,
                  size: 32,
                  color:
                      AppColors.primary,
                ),

                const SizedBox(
                  width: 16,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

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
                        height: 8,
                      ),

                      ...description.map(
                        (item) =>
                            Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 2,
                          ),

                          child: Text(
                            '• $item',

                            style:
                                const TextStyle(
                              fontSize: 14,

                              color:
                                  AppColors
                                      .textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color:
                      AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}