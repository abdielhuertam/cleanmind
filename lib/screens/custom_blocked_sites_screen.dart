import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../services/storage_service.dart';

class CustomBlockedSitesScreen
    extends StatefulWidget {

  final bool protectionActive;

  const CustomBlockedSitesScreen({
    super.key,
    required this.protectionActive,
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

    setState(() {
      _sites = loaded;
    });
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
                  'https://example.com',
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

  Future<void>
  _removeSite(
    int index,
  ) async {

    setState(() {
      _sites.removeAt(
        index,
      );
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
        widget.protectionActive;

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

              const SizedBox(
                height: 26,
              ),

              Row(
                children: [

                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },

                    icon: const Icon(
                      Icons.arrow_back_ios,

                      color:
                          AppColors
                              .primary,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Blocked Sites',

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        fontSize: 30,
                        fontWeight:
                            FontWeight.bold,

                        color:
                            AppColors
                                .primary,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed:
                        _showAddSiteDialog,

                    icon: const Icon(
                      Icons.add,

                      color:
                          AppColors
                              .primary,

                      size: 32,
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
                            ? 'Blocked sites cannot be modified while protection is active.'
                            : 'You can now edit or remove blocked sites.',

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
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox();
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
            vertical: 20,
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

              const Icon(
                Icons.public,

                color:
                    AppColors.primary,
              ),

              const SizedBox(
                width: 16,
              ),

              Expanded(
                child: Text(
                  site,

                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w600,
                  ),
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
                    width: 12,
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