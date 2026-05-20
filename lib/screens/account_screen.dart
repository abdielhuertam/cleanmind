import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../state/protection_state.dart';

import '../theme/app_colors.dart';

class AccountScreen extends StatelessWidget {
  final PlanState plan;

  const AccountScreen({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final isPremium = plan.isPro;

    final protection =
        plan.protection;

    final focusedDays =
        protection
            .getActiveDuration()
            .inDays;

    final unlockCount =
        protection.status ==
                ProtectionStatus
                    .protectionDisabled
            ? 1
            : 0;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileCard(
            isPremium,
          ),

          const SizedBox(height: 18),

          _buildStatsCard(
            focusedDays,
            unlockCount,
          ),

          const SizedBox(height: 18),

          _buildSubscriptionCard(
            isPremium,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    bool isPremium,
  ) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
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

      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,

            decoration:
                BoxDecoration(
              color:
                  AppColors.primary
                      .withOpacity(
                0.12,
              ),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.person,

              size: 36,

              color:
                  AppColors.primary,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                const Text(
                  'CleanMind Member',

                  maxLines: 1,

                  overflow:
                      TextOverflow
                          .ellipsis,

                  style: TextStyle(
                    fontSize: 19,
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
                  isPremium
                      ? 'Premium Plan'
                      : 'Free Plan',

                  style: const TextStyle(
                    fontSize: 15,

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

  Widget _buildStatsCard(
    int focusedDays,
    int unlockCount,
  ) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(
        24,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'Protection Stats',

            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,

              color:
                  AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: _statItem(
                  value:
                      '$focusedDays',
                  label:
                      'Focused Days',
                ),
              ),

              Expanded(
                child: _statItem(
                  value:
                      '$unlockCount',
                  label:
                      'Unlocks',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,

          style: const TextStyle(
            fontSize: 34,
            fontWeight:
                FontWeight.bold,

            color:
                AppColors.primary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          label,

          textAlign:
              TextAlign.center,

          style: const TextStyle(
            fontSize: 15,

            color:
                AppColors
                    .textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard(
    bool isPremium,
  ) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(
        24,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'Subscription',

            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,

              color:
                  AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            isPremium
                ? 'You currently have access to Premium unlock methods and accountability features.'
                : 'Upgrade to Premium to unlock SMS verification, Support approvals, and advanced protection features.',

            style: const TextStyle(
              fontSize: 16,
              height: 1.4,

              color:
                  AppColors
                      .textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}