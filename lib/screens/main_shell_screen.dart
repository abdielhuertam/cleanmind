import 'package:flutter/material.dart';

import '../state/plan_state.dart';

import '../theme/app_colors.dart';

import 'home_screen.dart';
import 'protection_screen.dart';
import 'account_screen.dart';
import 'pending_requests_screen.dart';
import 'community_screen.dart';

class MainShellScreen
    extends StatefulWidget {
  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

  const MainShellScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  static _MainShellScreenState? of(
    BuildContext context,
  ) {
    return context
        .findAncestorStateOfType<
            _MainShellScreenState>();
  }

  @override
  State<MainShellScreen> createState() =>
      _MainShellScreenState();
}

class _MainShellScreenState
    extends State<MainShellScreen> {

  int _selectedIndex = 0;

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final screens = [

      HomeScreen(
        plan: widget.plan,

        onPlanChanged:
            widget.onPlanChanged,
      ),

      ProtectionScreen(
        plan: widget.plan,

        onPlanChanged:
            widget.onPlanChanged,
      ),

      AccountScreen(
        plan: widget.plan,
      ),

      CommunityScreen(
        plan: widget.plan,
      ),
    ];

    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        bottom: false,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),

          child: Column(
            children: [

              Container(
                height: 18,

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
                      14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 0),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  Text(
                    _selectedIndex == 0
                        ? 'Home'
                        : _selectedIndex == 1
                        ? 'Protection'
                        : _selectedIndex == 2
                        ? 'Account'
                        : 'Community',

                    style: const TextStyle(
                      fontSize: 34,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          AppColors.primary,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  PendingRequestsScreen(
                                    plan:
                                        widget.plan,

                                    onPlanChanged:
                                        widget
                                            .onPlanChanged,
                                  ),
                        ),
                      );
                    },

                    child: Stack(
                      children: [

                        const Icon(
                          Icons.notifications,

                          size: 34,

                          color:
                              AppColors.primary,
                        ),

                        Positioned(
                          right: 0,

                          child: Container(
                            width: 14,
                            height: 14,

                            decoration:
                                BoxDecoration(
                              color:
                                  widget
                                          .plan
                                          .unlockRequest
                                          .isPending
                                      ? Colors.red
                                      : Colors.grey,

                              shape:
                                  BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child:
                    screens[_selectedIndex],
              ),
            ],
          ),
        ),
      ),

    bottomNavigationBar:
        SafeArea(
          top: false,

          child: Container(
          margin:
              const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            10,
          ),

        padding:
            const EdgeInsets.symmetric(
          vertical: 8,
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
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceEvenly,

          children: [

            _navItem(
              icon: Icons.home,

              label: 'Home',

              index: 0,
            ),

            _navItem(
              icon: Icons.shield,

              label: 'Protection',

              index: 1,
            ),

            _navItem(
              icon: Icons.person,

              label: 'Account',

              index: 2,
            ),

            _navItem(
              icon: Icons.groups,

              label: 'Community',

              index: 3,
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {

    final active =
        _selectedIndex == index;

    final color =
        active
            ? AppColors.primary
            : AppColors.textSecondary;

    return GestureDetector(
      onTap: () {
        changeTab(index);
      },

      child: Column(
        mainAxisSize:
            MainAxisSize.min,

        children: [

          Icon(
            icon,
            color: color,
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            label,

            style: TextStyle(
              fontSize: 11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}