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

    final hasSupport =
        isPremium;

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

              const SizedBox(height: 24),

              const Text(
                'Account',

                style: TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(height: 22),

              Expanded(
                child: ListView(
                  children: [
                    _buildProfileCard(
                      isPremium,
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    _buildSupportCard(
                      isPremium,
                      hasSupport,
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    _buildStatsCard(
                      focusedDays,
                      unlockCount,
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    _buildSubscriptionCard(
                      isPremium,
                    ),

                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    bool isPremium,
  ) {
    return Container(
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

          const SizedBox(width: 10),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),

            decoration:
                BoxDecoration(
              color:
                  isPremium
                      ? Colors.amber
                          .shade100
                      : Colors.grey
                          .shade200,

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: Text(
              isPremium
                  ? 'PREMIUM'
                  : 'FREE',

              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.bold,

                color:
                    isPremium
                        ? Colors
                            .orange
                            .shade800
                        : Colors.grey
                            .shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(
    bool isPremium,
    bool hasSupport,
  ) {
    return Container(
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
          Row(
            children: [
              const Icon(
                Icons.sms,

                color:
                    AppColors.primary,
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'Support Contact',

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,

                    color:
                        AppColors
                            .textPrimary,
                  ),
                ),
              ),

              if (isPremium)
                Icon(
                  Icons.workspace_premium,

                  color:
                      Colors.amber
                          .shade700,
                ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            hasSupport
                ? '+52 •••••• 0062'
                : 'No Support Added',

            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,

              color:
                  hasSupport
                      ? AppColors.primary
                      : Colors.grey,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            hasSupport
                ? 'Verification codes and unlock approvals are sent to your Support.'
                : 'Add a trusted person to receive verification codes and unlock approvals.',

            style: const TextStyle(
              fontSize: 16,
              height: 1.4,

              color:
                  AppColors
                      .textSecondary,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,

            height: 52,

            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    isPremium
                        ? AppColors
                            .primary
                        : Colors.grey
                            .shade400,

                foregroundColor:
                    Colors.white,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
              ),

              onPressed: () {},

              child: Text(
                !isPremium
                    ? 'Premium Required'
                    : hasSupport
                    ? 'Change Support'
                    : 'Add Support',

                style: const TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
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

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,

            height: 54,

            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    isPremium
                        ? Colors.green
                        : AppColors
                            .primary,

                foregroundColor:
                    Colors.white,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
              ),

              onPressed: () {},

              child: Text(
                isPremium
                    ? 'Manage Subscription'
                    : 'Upgrade to Premium',

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}