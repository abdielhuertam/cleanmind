import 'package:flutter/material.dart';

import '../state/plan_state.dart';

import '../theme/app_colors.dart';

import 'home_screen.dart';
import 'protection_screen.dart';
import 'account_screen.dart';

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

  @override
  State<MainShellScreen> createState() =>
      _MainShellScreenState();
}

class _MainShellScreenState
    extends State<MainShellScreen> {
  int _selectedIndex = 1;

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

      const _PlaceholderScreen(
        title: 'Community',
      ),
    ];

    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: screens[_selectedIndex],

      bottomNavigationBar:
          Container(
        margin: const EdgeInsets.all(16),

        padding:
            const EdgeInsets.symmetric(
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(28),

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
              disabled: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
    bool disabled = false,
  }) {
    final active =
        _selectedIndex == index;

    final color =
        disabled
            ? Colors.grey.shade400
            : active
            ? AppColors.primary
            : AppColors.textSecondary;

    return GestureDetector(
      onTap:
          disabled
              ? null
              : () {
                setState(() {
                  _selectedIndex =
                      index;
                });
              },

      child: Opacity(
        opacity: disabled ? 0.5 : 1,

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Icon(
              icon,
              color: color,
            ),

            const SizedBox(height: 4),

            Text(
              label,

              style: TextStyle(
                fontSize: 11,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderScreen
    extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: Center(
        child: Text(
          title,

          style: const TextStyle(
            fontSize: 32,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }
}