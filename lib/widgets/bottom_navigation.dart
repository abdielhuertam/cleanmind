import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BottomNavigation
    extends StatelessWidget {
  final bool isPro;

  const BottomNavigation({
    super.key,
    required this.isPro,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            MainAxisAlignment.spaceEvenly,

        children: [
          _item(
            Icons.home,
            'Home',
            false,
          ),

          _item(
            Icons.shield,
            'Protection',
            true,
          ),

          _item(
            Icons.person,
            'Account',
            false,
          ),

          _item(
            Icons.groups,
            'Community',
            false,
            disabled: true,
          ),

          _item(
            Icons.settings,
            'Config',
            false,
          ),

          if (!isPro)
            _item(
              Icons.workspace_premium,
              'Premium',
              false,
              premium: true,
            ),
        ],
      ),
    );
  }

  Widget _item(
    IconData icon,
    String label,
    bool active, {
    bool premium = false,
    bool disabled = false,
  }) {
    final color =
        disabled
            ? Colors.grey.shade400
            : premium
            ? Colors.amber
            : active
            ? AppColors.primary
            : AppColors.textSecondary;

    return Opacity(
      opacity: disabled ? 0.6 : 1,

      child: Column(
        mainAxisSize: MainAxisSize.min,

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
    );
  }
}