import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../services/storage_service.dart';

class SupportCleanMindUserScreen extends StatefulWidget {
  const SupportCleanMindUserScreen({
    super.key,
  });

  @override
  State<SupportCleanMindUserScreen> createState() =>
      _SupportCleanMindUserScreenState();
}

class _SupportCleanMindUserScreenState
    extends State<SupportCleanMindUserScreen> {
  final TextEditingController
      _searchController =
      TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        elevation: 0,
        title: const Text(
          'Add CleanMind User',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [
            const Text(
              'Find your Support',
              style: TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.bold,
                color:
                    AppColors.textPrimary,
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            const Text(
              'Enter the email address of an existing CleanMind user.',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color:
                    AppColors.textSecondary,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
                  _searchController,

              decoration:
                  InputDecoration(
                hintText:
                     'Email address',

                prefixIcon:
                    const Icon(
                  Icons.search,
                  color:
                      AppColors.primary,
                ),

                filled: true,
                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  borderSide:
                      BorderSide.none,
                ),

                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  borderSide:
                      BorderSide(
                    color: Colors.grey
                        .shade300,
                  ),
                ),

                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  borderSide:
                      const BorderSide(
                    color:
                        AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            SizedBox(
              height: 54,

              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                  foregroundColor:
                      Colors.white,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),

                onPressed: () async {
                  final query =
                      _searchController.text.trim();

                  if (query.isEmpty) {
                    return;
                  }

                  final emailRegex = RegExp(
                    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                  );

                  if (!emailRegex.hasMatch(query)) {
                    await showDialog<void>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          title: const Text(
                            'Invalid Email',
                          ),
                          content: const Text(
                            'Enter a valid email address.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );

                    return;
}

                  // TEMPORARY MOCK.
                  // Replace with Firebase user search later.

                  if (!mounted) return;

                  await showDialog<void>(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        title: const Text(
                          'User Found',
                        ),
                        content: Text(
                          'CleanMind user:\n\n$query\n\nDo you want to add this user as your Support?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await StorageService.saveSupportName(
                                query,
                              );

                              await StorageService.saveSupportPhone(
                                '',
                              );

                              await StorageService.saveSupportType(
                                'cleanMindUser',
                              );

                              if (!dialogContext.mounted) return;

                              Navigator.pop(dialogContext);

                              if (!mounted) return;

                              Navigator.pop(context, true);
                            },
                            child: const Text(
                              'Add Support',
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },

                child: const Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                14,
              ),

              decoration:
                  BoxDecoration(
                color: const Color(
                  0xFFE5EEFC,
                ),

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Icon(
                    Icons
                        .notifications_active_outlined,
                    color:
                        AppColors.primary,
                  ),

                  SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Text(
                      'Once connected, your Support can receive push notifications to approve or deny protection deactivation requests.',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}