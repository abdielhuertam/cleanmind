import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProtectionStatusOverlay {
  static OverlayEntry? _currentOverlay;

  static Future<void> show({
    required BuildContext context,
    required bool activated,
  }) async {
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (_) => _ProtectionStatusWidget(
        activated: activated,
      ),
    );

    _currentOverlay = entry;
    overlay.insert(entry);

    await Future.delayed(
      const Duration(seconds: 3),
    );

    entry.remove();

    if (_currentOverlay == entry) {
      _currentOverlay = null;
    }
  }

  static Future<void> showActivated(
    BuildContext context,
  ) {
    return show(
      context: context,
      activated: true,
    );
  }

  static Future<void> showDisabled(
    BuildContext context,
  ) {
    return show(
      context: context,
      activated: false,
    );
  }
}

class _ProtectionStatusWidget extends StatelessWidget {
  final bool activated;

  const _ProtectionStatusWidget({
    required this.activated,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Material(
        color: Colors.black26,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 250,
            ),
            width: 260,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Icon(
                  Icons.shield,
                  size: 60,
                  color: activated
                      ? AppColors.primary
                      : Colors.grey,
                ),

                const SizedBox(height: 20),

                Text(
                  activated
                      ? 'Protection Activated'
                      : 'Protection Disabled',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  activated
                      ? 'Content blocking is now active.'
                      : 'Content blocking has been turned off.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}