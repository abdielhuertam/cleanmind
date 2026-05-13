import 'package:flutter/material.dart';

import 'primary_button.dart';

class ProtectionActions extends StatelessWidget {
  final VoidCallback onRequestUnlock;

  const ProtectionActions({
    super.key,
    required this.onRequestUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: 'Request Unlock',
      onPressed: onRequestUnlock,
    );
  }
}