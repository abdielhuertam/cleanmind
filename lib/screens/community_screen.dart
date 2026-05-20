import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../state/plan_state.dart';

class CommunityScreen
    extends StatelessWidget {
  final PlanState plan;

  const CommunityScreen({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final pending =
        plan.unlockRequest.isPending;

    final focusedDays =
        plan.protection
            .getActiveDuration()
            .inDays;

    return SingleChildScrollView(
      child: Column(
        children: [

          _sectionCard(
            child: Column(
              children: [
                Row(
                  children: [

                    Container(
                      width: 58,
                      height: 58,

                      decoration:
                          BoxDecoration(
                        color:
                            AppColors.primary
                                .withOpacity(
                          0.1,
                        ),

                        shape:
                            BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.support_agent,

                        size: 30,

                        color:
                            AppColors.primary,
                      ),
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

                          const Text(
                            'Trusted Support',

                            style: TextStyle(
                              fontSize: 20,

                              fontWeight:
                                  FontWeight.bold,

                              color:
                                  AppColors
                                      .textPrimary,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            pending
                                ? 'Approval request pending'
                                : 'Support connected',

                            style:
                                TextStyle(
                              fontSize: 15,

                              color:
                                  pending
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 24,
                ),

                Container(
                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(
                    18,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        AppColors
                            .background,

                    borderRadius:
                        BorderRadius.circular(
                      22,
                    ),
                  ),

                  child: Column(
                    children: [

                      Text(
                        '$focusedDays',

                        style:
                            const TextStyle(
                          fontSize: 40,

                          fontWeight:
                              FontWeight.bold,

                          color:
                              AppColors
                                  .primary,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      const Text(
                        'Focused Days',

                        style: TextStyle(
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
          ),

          const SizedBox(
            height: 18,
          ),

          _sectionCard(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                const Text(
                  'Recent Activity',

                  style: TextStyle(
                    fontSize: 20,

                    fontWeight:
                        FontWeight.bold,

                    color:
                        AppColors
                            .textPrimary,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                _activityTile(
                  icon:
                      Icons.check_circle,

                  color:
                      Colors.green,

                  title:
                      'Protection Active',

                  subtitle:
                      'Your protection system is running normally.',
                ),

                const SizedBox(
                  height: 14,
                ),

                _activityTile(
                  icon:
                      pending
                          ? Icons.schedule
                          : Icons.groups,

                  color:
                      pending
                          ? Colors.orange
                          : AppColors
                              .primary,

                  title:
                      pending
                          ? 'Approval Pending'
                          : 'Support Connected',

                  subtitle:
                      pending
                          ? 'Waiting for approval response.'
                          : 'Your accountability support is active.',
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          _sectionCard(
            child: Column(
              children: [

                const Icon(
                  Icons.lightbulb,

                  size: 54,

                  color:
                      Colors.orange,
                ),

                const SizedBox(
                  height: 18,
                ),

                const Text(
                  'Daily Motivation',

                  style: TextStyle(
                    fontSize: 22,

                    fontWeight:
                        FontWeight.bold,

                    color:
                        AppColors
                            .textPrimary,
                  ),
                ),

                const SizedBox(
                  height: 14,
                ),

                const Text(
                  'Every focused day strengthens your discipline and mental clarity.',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(
                    fontSize: 16,
                    height: 1.45,

                    color:
                        AppColors
                            .textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(
        22,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          28,
        ),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: child,
    );
  }

  Widget _activityTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [

        Container(
          width: 50,
          height: 50,

          decoration:
              BoxDecoration(
            color:
                color.withOpacity(
              0.12,
            ),

            shape:
                BoxShape.circle,
          ),

          child: Icon(
            icon,
            color: color,
          ),
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

                style: const TextStyle(
                  fontSize: 17,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors
                          .textPrimary,
                ),
              ),

              const SizedBox(
                height: 4,
              ),

              Text(
                subtitle,

                style: const TextStyle(
                  fontSize: 14,
                  height: 1.35,

                  color:
                      AppColors
                          .textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}