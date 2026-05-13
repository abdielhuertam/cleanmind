import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../theme/app_colors.dart';

class ProtectionScreen extends StatelessWidget {
  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

  const ProtectionScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  Widget build(BuildContext context) {
    final status =
        plan.protection.status;

    final isProtectionActive =
        status.name !=
            'protectionDisabled' &&
        status.name != 'inactive';

    final focusedDays =
        plan.protection
            .getActiveDuration()
            .inDays;

    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),

          child: Column(
            children: [
              Container(
                height: 42,

                decoration:
                    const BoxDecoration(
                  color:
                      AppColors.primary,

                  borderRadius:
                      BorderRadius.only(
                    bottomLeft:
                        Radius.circular(
                      22,
                    ),

                    bottomRight:
                        Radius.circular(
                      22,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              const Text(
                'Clean Mind',

                style: TextStyle(
                  fontSize: 34,
                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(
                  26,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Icon(
                      Icons.shield,

                      size: 82,

                      color:
                          isProtectionActive
                              ? AppColors
                                  .primary
                              : Colors.red,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [
                        Text(
                          isProtectionActive
                              ? 'Protection Active'
                              : 'Protection Disabled',

                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight
                                    .bold,

                            color:
                                AppColors
                                    .textPrimary,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Container(
                          width: 16,
                          height: 16,

                          decoration:
                              BoxDecoration(
                            color:
                                isProtectionActive
                                    ? Colors
                                        .green
                                    : Colors.red,

                            shape:
                                BoxShape.circle,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      '$focusedDays',

                      style: const TextStyle(
                        fontSize: 62,
                        fontWeight:
                            FontWeight.bold,

                        color:
                            AppColors.primary,
                      ),
                    ),

                    const Text(
                      'days focused',

                      style: TextStyle(
                        fontSize: 22,
                        color:
                            AppColors
                                .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      isProtectionActive
                          ? AppColors.primary
                          : Colors.green,

                  foregroundColor:
                      Colors.white,

                  minimumSize:
                      const Size(
                    double.infinity,
                    62,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      22,
                    ),
                  ),
                ),

                onPressed: () async {
                  if (!isProtectionActive) {
                    final updatedPlan =
                        plan
                            .manualReactivate();

                    onPlanChanged(
                      updatedPlan,
                    );

                    return;
                  }

                  await Navigator.pushNamed(
                    context,
                    '/unlock-methods',
                  );

                  if (!context.mounted) {
                    return;
                  }

                  Navigator.pushReplacementNamed(
                    context,
                    '/',
                  );
                },

                child: Text(
                  isProtectionActive
                      ? 'Request Unlock'
                      : 'Activate Protection',

                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}