import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../theme/app_colors.dart';
import 'custom_duration_screen.dart';
import 'partial_protection_confirmation_screen.dart';


class PartialDurationSelectionScreen
    extends StatelessWidget {

  final PlanState plan;

  final ValueChanged<PlanState>
    onPlanChanged;

  const PartialDurationSelectionScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  Future<void> _showPremiumDialog(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Premium Required',
          ),
          content: const Text(
            'Unlock custom durations and shorter focus sessions with CleanMind Premium.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Not Now',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Premium subscriptions are not available yet.',
                    ),
                  ),
                );
              },
              child: const Text(
                'Get Premium',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final freeOptions = [
      '8 Hours',
      '12 Hours',
      '24 Hours',
    ];

    final premiumOptions = [
      '1 Hour',
      '2 Hours',
      '4 Hours',
      'Custom',
    ];

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        backgroundColor:
            AppColors.primary,
        foregroundColor:
            Colors.white,
        title: const Text(
          'Partial Protection',
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Center(
              child: Column(
                children: [

                  const Icon(
                    Icons.eco,
                    size: 42,
                    color:
                        AppColors.success,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  const Text(
                    'Stay focused for a short period',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(
                    'Choose how long you want protection to remain active.',
                    textAlign:
                        TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            const Text(
              'FREE',
              style: TextStyle(
                color:
                    AppColors.primary,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            ...freeOptions.map(
              (option) =>
                  _durationCard(
                label: option,
                icon: Icons.schedule,
                onTap: () {

                  Duration selectedDuration;

                  switch (option) {
                    case '8 Hours':
                      selectedDuration =
                          const Duration(hours: 8);
                      break;

                    case '12 Hours':
                      selectedDuration =
                          const Duration(hours: 12);
                      break;

                    default:
                      selectedDuration =
                          const Duration(hours: 24);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PartialProtectionConfirmationScreen(
                            plan: plan,
                            onPlanChanged:
                                onPlanChanged,
                            selectedDuration:
                                selectedDuration,
                          ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'PREMIUM',
              style: TextStyle(
                color:
                    AppColors.primary,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            ...premiumOptions.map(
              (option) =>
                  _durationCard(
                label: option,
                icon:
                    Icons.schedule,
                premium: true,
                locked:
                    !plan.isPro,
                onTap: () {

                  if (!plan.isPro) {
                    _showPremiumDialog(
                      context,
                    );
                    return;
                  }

                  if (option == 'Custom') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomDurationScreen(
                          plan: plan,
                          onPlanChanged: onPlanChanged,
                        ),
                      ),
                    );
                    return;
                  }

                  Duration selectedDuration;

                  switch (option) {
                    case '1 Hour':
                      selectedDuration = const Duration(hours: 1);
                      break;

                    case '2 Hours':
                      selectedDuration = const Duration(hours: 2);
                      break;

                    default:
                      selectedDuration = const Duration(hours: 4);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PartialProtectionConfirmationScreen(
                        plan: plan,
                        onPlanChanged: onPlanChanged,
                        selectedDuration: selectedDuration,
                      ),
                    ),
                  );
                },
              ),
            ),

            if (!plan.isPro) ...[

              const SizedBox(
                height: 20,
              ),

              Container(
                width:
                    double.infinity,

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
                    20,
                  ),
                ),

                child: Column(
                  children: [

                    const Icon(
                      Icons.workspace_premium,
                      size: 36,
                      color:
                          Colors.orange,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Text(
                      'Get CleanMind Premium',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      'Access custom durations and maintain your focus without limits.',
                      textAlign:
                          TextAlign.center,
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    SizedBox(
                      width:
                          double.infinity,

                      child:
                          ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primary,
                          foregroundColor:
                              Colors.white,
                        ),

                        onPressed: () {
                          _showPremiumDialog(
                            context,
                          );
                        },

                        child: const Text(
                          'View Premium Benefits',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _durationCard({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool premium = false,
    bool locked = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),

          decoration:
              BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),

          child: Row(
            children: [

              Icon(
                icon,
                color:
                    AppColors.primary,
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Text(
                  label,
                ),
              ),

              if (premium)
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.orange,
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
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

              if (locked)
                const Padding(
                  padding:
                      EdgeInsets.only(
                    left: 8,
                  ),
                  child: Icon(
                    Icons.lock,
                    color: Colors.grey,
                    size: 18,
                  ),
                ),

              const SizedBox(
                width: 8,
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color:
                    AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
