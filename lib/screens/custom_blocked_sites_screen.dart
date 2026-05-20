import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../services/storage_service.dart';

import '../state/plan_state.dart';
import '../state/protection_state.dart';

class CustomBlockedSitesScreen
    extends StatefulWidget {
  final PlanState plan;

  const CustomBlockedSitesScreen({
    super.key,
    required this.plan,
  });

  @override
  State<CustomBlockedSitesScreen>
      createState() =>
          _CustomBlockedSitesScreenState();
}

class _CustomBlockedSitesScreenState
    extends State<
      CustomBlockedSitesScreen
    > {
  List<String> _sites = [];

  @override
  void initState() {
    super.initState();

    _loadSites();
  }

  Future<void> _loadSites()
  async {
    final loaded =
        await StorageService
            .loadBlockedSites();

    if (!mounted) return;

    setState(() {
      _sites = loaded;
    });
  }

  bool get _protectionActive {
    final status =
        widget.plan.protection.status;

    return status !=
            ProtectionStatus
                .protectionDisabled &&
        status !=
            ProtectionStatus
                .inactive;
  }

  void _showAddSiteDialog({
    String? existingSite,
    int? editIndex,
  }) {
    final controller =
        TextEditingController(
      text: existingSite,
    );

    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              24,
            ),
          ),

          title: Text(
            existingSite == null
                ? 'Add Website'
                : 'Edit Website',
          ),

          content: TextField(
            controller: controller,

            decoration:
                const InputDecoration(
              hintText:
                  'example.com',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },

              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                final value =
                    controller.text
                        .trim();

                if (value
                    .isNotEmpty) {
                  setState(() {
                    if (editIndex !=
                        null) {
                      _sites[
                              editIndex] =
                          value;
                    } else {
                      _sites.add(
                        value,
                      );
                    }
                  });

                  await StorageService
                      .saveBlockedSites(
                    _sites,
                  );
                }

                if (!mounted) {
                  return;
                }

                Navigator.pop(
                  context,
                );
              },

              child: Text(
                existingSite == null
                    ? 'Add'
                    : 'Save',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeSite(
    int index,
  ) async {
    setState(() {
      _sites.removeAt(index);
    });

    await StorageService
        .saveBlockedSites(
      _sites,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final protectionActive =
        _protectionActive;

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
          'Blocked Sites',
        ),

        actions: [
          IconButton(
            onPressed:
                _showAddSiteDialog,

            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),

      body: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),

        child: Column(
          children: [
            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  22,
                ),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(
                      0,
                      4,
                    ),
                  ),
                ],
              ),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Icon(
                    protectionActive
                        ? Icons.lock
                        : Icons.edit,

                    color:
                        AppColors
                            .primary,
                  ),

                  const SizedBox(
                    width: 14,
                  ),

                  Expanded(
                    child: Text(
                      protectionActive
                          ? 'You can add new blocked websites while protection is active, but existing protections cannot be modified.'
                          : 'You can now add, edit, or remove blocked websites.',

                      style:
                          const TextStyle(
                        fontSize: 15,
                        height: 1.4,

                        color:
                            AppColors
                                .textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            Expanded(
              child:
                  _sites.isEmpty
                      ? _buildEmptyState()
                      : _buildSitesList(
                          protectionActive,
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        width: double.infinity,

        padding:
            const EdgeInsets.all(
          32,
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

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            const Icon(
              Icons.public_off,

              size: 72,

              color:
                  AppColors.primary,
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'No Blocked Websites',

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,

                color:
                    AppColors
                        .textPrimary,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              'Add websites you want CleanMind to protect you from.',

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

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width: double.infinity,

              height: 54,

              child: ElevatedButton(
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      AppColors.primary,

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

                onPressed:
                    _showAddSiteDialog,

                child: const Text(
                  'Add Website',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSitesList(
    bool protectionActive,
  ) {
    return ListView.builder(
      itemCount:
          _sites.length,

      itemBuilder: (
        context,
        index,
      ) {
        final site =
            _sites[index];

        return Container(
          margin:
              const EdgeInsets.only(
            bottom: 14,
          ),

          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
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
                offset: Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,

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
                  Icons.public,

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
                    Text(
                      site,

                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w600,

                        color:
                            AppColors
                                .textPrimary,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    const Text(
                      'Protected website',

                      style: TextStyle(
                        fontSize: 14,

                        color:
                            AppColors
                                .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  if (protectionActive)
                    const Icon(
                      Icons.lock,

                      size: 18,

                      color: Colors.grey,
                    ),

                  if (!protectionActive)
                    GestureDetector(
                      onTap: () {
                        _showAddSiteDialog(
                          existingSite:
                              site,

                          editIndex:
                              index,
                        );
                      },

                      child: const Icon(
                        Icons.edit_outlined,

                        size: 20,

                        color:
                            AppColors.primary,
                      ),
                    ),

                  const SizedBox(
                    width: 14,
                  ),

                  GestureDetector(
                    onTap:
                        protectionActive
                            ? null
                            : () async {
                                await _removeSite(
                                  index,
                                );
                              },

                    child: Icon(
                      Icons.delete_outline,

                      color:
                          protectionActive
                              ? Colors.grey
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}