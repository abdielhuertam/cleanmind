import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../state/plan_state.dart';
import '../state/protection_state.dart';

import '../models/user_profile.dart';
import '../services/local_user_profile_repository.dart';
import '../services/user_profile_repository.dart';


class AccountSettingsScreen
    extends StatefulWidget {

  final PlanState plan;

  const AccountSettingsScreen({
    super.key,
    required this.plan,
  });

  @override
  State<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState
    extends State<AccountSettingsScreen> {
    final UserProfileRepository
        _repository =
        userProfileRepository;

  UserProfile? _profile;

    Future<void> _editUsername() async {
    final controller = TextEditingController(
        text: _profile?.username ?? '',
    );

    final result = await showDialog<String>(
        context: context,
        builder: (context) {
        return AlertDialog(
            title: const Text('Edit Username'),
            content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
                labelText: 'Username',
            ),
            ),
            actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
            ),
            FilledButton(
                onPressed: () => Navigator.pop(
                context,
                controller.text.trim(),
                ),
                child: const Text('Save'),
            ),
            ],
        );
        },
    );

    if (result == null ||
        result.isEmpty ||
        result == _profile?.username) {
        return;
    }

    await _repository.updateUsername(result);

    await _loadProfile();
    }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile =
        await _repository.getProfile();

    if (!mounted) return;

    setState(() {
      _profile = profile;
    });
  }

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
          'Account Settings',
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
                color: Color(0xFFEAF2FF),
                shape: BoxShape.circle,
            ),
            child: const Icon(
                Icons.shield,
                size: 54,
                color: AppColors.primary,
            ),
            ),

            const SizedBox(height: 28),

            _accountField(
              icon:
                  Icons.person_outline,
              label:
                  'Name and Last Name',
                value:
                    _profile?.fullName ??
                    '',
              editable: false,
            ),

            const SizedBox(height: 14),

            _accountField(
            icon:
                Icons.alternate_email,
            label:
                'Username',
            value:
                _profile?.username ??
                '',
            editable: true,
            onEdit: _editUsername,
            ),

            const SizedBox(height: 14),

            _accountField(
              icon:
                  Icons.email_outlined,
              label:
                  'Email',
                value:
                    _profile?.email ??
                    '',
              editable: false,
            ),

            const SizedBox(height: 14),

            _accountField(
            icon: Icons.workspace_premium_outlined,
            label: 'Plan',
            value: widget.plan.hasSupport
                ? 'Pro + Support'
                : widget.plan.isPro
                    ? 'Pro'
                    : 'Free',
            editable: false,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {

                if (widget.plan.protection.status ==
                    ProtectionStatus.active) {
                    await showDialog<void>(
                    context: context,
                    builder: (dialogContext) {
                        return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                        ),
                        title: const Text(
                            'Protection is Active',
                        ),
                        content: const Text(
                            'To delete your account, you must first disable protection.\n\nOnce protection is turned off, you can return here to permanently delete your account.',
                        ),
                        actions: [
                            TextButton(
                            onPressed: () {
                                Navigator.pop(dialogContext);
                            },
                            child: const Text(
                                'OK',
                            ),
                            ),
                        ],
                        );
                    },
                    );

                    return;
                }

                await showDialog<void>(
                    context: context,
                    builder: (dialogContext) {
                    return AlertDialog(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        ),
                        title: const Text(
                        'Delete Account',
                        ),
                        content: const Text(
                        'This action will permanently delete your CleanMind account.\n\nThis cannot be undone.',
                        ),
                        actions: [
                        TextButton(
                            onPressed: () {
                            Navigator.pop(dialogContext);
                            },
                            child: const Text(
                            'Cancel',
                            ),
                        ),
                        FilledButton(
                            style: FilledButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            ),
                            onPressed: () {
                            Navigator.pop(dialogContext);
                            },
                            child: const Text(
                            'Delete',
                            ),
                        ),
                        ],
                    );
                    },
                );
                },
                icon: const Icon(
                  Icons.delete_outline,
                ),
                label: const Text(
                  'Delete Account',
                ),
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      AppColors.danger,
                  side: const BorderSide(
                    color:
                        AppColors.danger,
                  ),
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _accountField({
    required IconData icon,
    required String label,
    required String value,
    required bool editable,
    VoidCallback? onEdit,
    }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      const TextStyle(
                    fontSize: 13,
                    color: AppColors
                        .textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style:
                      const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w600,
                    color: AppColors
                        .textPrimary,
                  ),
                ),
              ],
            ),
          ),

            if (editable)
            IconButton(
                onPressed: onEdit,
                icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
                ),
            ),
        ],
      ),
    );
  }
}