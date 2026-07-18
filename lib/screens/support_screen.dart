import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../services/storage_service.dart';
import '../state/plan_state.dart';
import '../services/user_profile_repository.dart';
import '../models/user_profile.dart';

import 'support_cleanmind_user_screen.dart';
import 'support_phone_screen.dart';
import 'support_verification_screen.dart';


class SupportScreen extends StatefulWidget {
  final PlanState plan;
  final ValueChanged<PlanState> onPlanChanged;

  const SupportScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  State<SupportScreen> createState() =>
      _SupportScreenState();
}

class _SupportScreenState
    extends State<SupportScreen> {
  String? _supportName;
  String? _supportPhone;
  String? _supportType;
  String? _supportStatus;

  @override
  void initState() {
    super.initState();
    _loadSupport();
  }

  Future<void> _loadSupport() async {
    final name =
        await StorageService.loadSupportName();

    final phone =
        await StorageService.loadSupportPhone();

    final type =
        await StorageService.loadSupportType();

    final status =
        await StorageService.loadSupportStatus();

    if (!mounted) return;

    setState(() {
      _supportName = name;
      _supportPhone = phone;
      _supportType = type;
      _supportStatus = status;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Support',
        ),
      ),

    body: _supportName != null &&
            _supportName!.isNotEmpty &&
            _supportType != null
        ? _buildConfiguredSupport()
        : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [
            const SizedBox(height: 4),

            Center(
              child: Container(
                width: 64,
                height: 64,

                decoration: const BoxDecoration(
                  color: Color(0xFFE2EBFA),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.people_outline,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              'Add a Support Partner',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Text(
                'Add someone you trust to help approve\nprotection deactivation requests.',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Divider(
              color: Colors.grey.shade300,
              height: 1,
            ),

            const SizedBox(height: 18),

            const Text(
              'How do you want to add your Support?',

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),

            const SizedBox(height: 12),

            _supportOption(
              icon: Icons.people_outline,

              title:
                  'CleanMind User',

              subtitle:
                  'Search by email.\nThey’ll receive push notifications\nin the app.',

              badge:
                  'Recommended',

              isRecommended:
                  true,

              onTap: () async {
                final added = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SupportCleanMindUserScreen(),
                  ),
                );

                if (added == true && mounted) {
                  await _loadSupport();
                }
              },
            ),

            const SizedBox(height: 12),

            _supportOption(
              icon:
                  Icons.sms_outlined,

              title:
                  'Phone Number',

              subtitle:
                  'They’ll receive SMS codes.\nFor contacts who don’t have\nCleanMind.',

                onTap: () async {
                final added = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                    builder: (_) =>
                        const SupportPhoneScreen(),
                    ),
                );

                if (added == true && context.mounted) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                    builder: (_) =>
                        SupportScreen(
                          plan: widget.plan,
                          onPlanChanged:
                              widget.onPlanChanged,
                        ),
                    ),
                );
                }
                },
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),

              decoration: BoxDecoration(
                color: const Color(
                  0xFFE5EEFC,
                ),

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),

                border: Border.all(
                  color: const Color(
                    0xFFB8D0F5,
                  ),
                ),
              ),

              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: AppColors.primary,
                    size: 23,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'You can change or remove your Support at any time. It will require verification.',

                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            ],
        ),
      ),
    );
  }

    Widget _buildConfiguredSupport() {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
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
                Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                    color: Color(0xFFE5EEFC),
                    shape: BoxShape.circle,
                    ),
                    child: const Icon(
                    Icons.person_outline,
                    size: 38,
                    color: AppColors.primary,
                    ),
                ),

                const SizedBox(height: 14),

                Text(
                    _supportName!,
                    style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    ),
                ),

                const SizedBox(height: 5),

                Text(
                    _supportPhone!,
                    style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    ),
                ),

                const SizedBox(height: 12),

                Container(
                    padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                    ),
                    decoration: BoxDecoration(
                    color: _supportStatus == 'pendingRemoval'
                        ? const Color(0xFFFFF3CD)
                        : const Color(0xFFE1F4E7),
                    borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Icon(
                        _supportStatus == 'pendingRemoval'
                            ? Icons.schedule
                            : Icons.check_circle,
                        size: 17,
                        color: AppColors.success,
                        ),
                        SizedBox(width: 6),
                        Text(
                        _supportStatus == 'pendingRemoval'
                            ? 'Pending Removal'
                            : 'Active',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                        ),
                        ),
                    ],
                    ),
                ),

                const SizedBox(height: 20),

                const Divider(height: 1),

                const SizedBox(height: 16),

                Row(
                    children: [
                    Icon(
                        _supportType == 'cleanMindUser'
                            ? Icons.notifications_active_outlined
                            : Icons.sms_outlined,
                        color: AppColors.primary,
                        size: 22,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                        child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                            Text(
                            'Approval Method',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                            ),
                            ),
                            SizedBox(height: 3),
                            Text(
                            _supportType == 'cleanMindUser'
                                ? 'Push Notification'
                                : 'SMS Verification Code',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                            ),
                            ),
                        ],
                        ),
                    ),
                    ],
                ),
                ],
            ),
            ),

            if (_supportStatus == 'pendingRemoval') ...[
              const SizedBox(height: 18),

              _supportOption(
                icon: Icons.cancel_outlined,
                title: 'Cancel Removal Request',
                subtitle:
                    'Cancel the pending request and keep your current Support.',
                    showArrow: false,
                onTap: () async {
                  await StorageService.saveSupportStatus(
                    'active',
                  );

                  await StorageService
                      .clearSupportRemovalRequestId();

                  final updatedPlan =
                      widget.plan.clearSupportRequest();

                  widget.onPlanChanged(
                    updatedPlan,
                  );

                  if (!mounted) return;

                  setState(() {
                    _supportStatus = 'active';
                  });
                },
              ),
            ],

            if (_supportStatus != 'pendingRemoval') ...[
              const SizedBox(height: 18),

              _supportOption(
              icon: Icons.swap_horiz,
              title: 'Change Support',
              subtitle:
                  'Replace your current Support partner.',
              onTap: () {
                  // Verification flow next.
              },
              ),

              const SizedBox(height: 12),

              _supportOption(
              icon: Icons.person_remove_outlined,
              title: 'Remove Support',
              subtitle:
                  'Requires verification from your current Support.',
              onTap: () async {
              final confirmed =
                  await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(24),
                      ),
                      title: const Text(
                      'Remove Support?',
                      ),
                      content: Text(
                      'A verification code will be sent to your current Support:\n\n'
                      '${_supportName!}\n'
                      '${_supportPhone!}\n\n'
                      'Do you want to continue?',
                      ),
                      actions: [
                      TextButton(
                          onPressed: () {
                          Navigator.pop(
                              dialogContext,
                              false,
                          );
                          },
                          child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                          Navigator.pop(
                              dialogContext,
                              true,
                          );
                          },
                      child: Text(
                        _supportType == 'cleanMindUser'
                            ? 'Send Notification'
                            : 'Send Code',
                      ),
                      ),
                      ],
                  );
                  },
              );

              if (confirmed != true || !mounted) {
                return;
              }

              if (_supportType == 'cleanMindUser') {
                // TODO: Send real push notification through backend.

              await StorageService.saveSupportStatus(
                'pendingRemoval',
              );

              final UserProfile? profile =
                  await userProfileRepository.getProfile();

              final updatedPlan =
                  widget.plan.startSupportRemovalRequest(
                requesterName:
                    profile?.username ??
                    profile?.email ??
                    'Unknown User',
              );

              final requestId =
                  updatedPlan.supportRequest.requestId;

              if (requestId != null) {
                await StorageService
                    .saveSupportRemovalRequestId(
                  requestId,
                );
              }

              widget.onPlanChanged(
                updatedPlan,
              );

              if (!mounted) return;

              setState(() {
                _supportStatus = 'pendingRemoval';
              });

                return;
              }

              // SMS Support flow continues here.

              final verified =
                  await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                  builder: (_) =>
                      const SupportVerificationScreen(),
                  ),
              );

              if (verified != true || !mounted) {
                return;
              }

              await StorageService.clearSupport();

              if (!mounted) return;

              setState(() {
                _supportName = null;
                _supportPhone = null;
                _supportType = null;
              });

              await showDialog<void>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Support Removed',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your Support was removed successfully.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Done'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
              },
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EEFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFB8D0F5),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.primary,
                      size: 23,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Changing or removing your Support requires verification.',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
    );
  }

  Widget _supportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? badge,
    bool isRecommended = false,
    bool showArrow = true,
  }) {
    return Material(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(
        22,
      ),

      elevation: 3,

      shadowColor:
          Colors.black26,

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),

          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              22,
            ),

            border: isRecommended
                ? Border.all(
                    color:
                        AppColors.success,
                    width: 1,
                  )
                : null,
          ),

          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,

            children: [
              Container(
                width: 48,
                height: 48,

                decoration:
                    const BoxDecoration(
                  color: Color(
                    0xFFE5EEFC,
                  ),
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  icon,
                  color:
                      AppColors.primary,
                  size: 27,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,

                            style:
                                const TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.bold,
                              color: Color(
                                0xFF1F2937,
                              ),
                            ),
                          ),
                        ),

                        if (badge != null)
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),

                            decoration:
                                BoxDecoration(
                              color: const Color(
                                0xFFE1F4E7,
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                10,
                              ),
                            ),

                            child: Text(
                              badge,

                              style:
                                  const TextStyle(
                                fontSize: 9,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    AppColors.success,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,

                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              if (showArrow)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 17,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}