import 'dart:math';
import 'package:flutter/material.dart';
import '../state/plan_state.dart';

class AccountabilityCodeScreen extends StatefulWidget {
  final PlanState plan;
  final ValueChanged<PlanState> onPlanChanged;

  const AccountabilityCodeScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  State<AccountabilityCodeScreen> createState() =>
      _AccountabilityCodeScreenState();
}

class _AccountabilityCodeScreenState
    extends State<AccountabilityCodeScreen> {
  final TextEditingController _controller = TextEditingController();
  late final String _generatedCode;

  @override
  void initState() {
    super.initState();
    _generatedCode = _generateCode();
  }

  String _generateCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  void _cancel() {
    // Restore protection to active
    widget.onPlanChanged(widget.plan.activateProtection());
    Navigator.of(context).pop();
  }

  void _verifyCode() {
    if (_controller.text.trim() == _generatedCode) {
      widget.onPlanChanged(widget.plan.unlockSucceeded());
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid code'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final message =
        'A friend is asking for your support to temporarily disable protection.\n\n'
        'Share this code with them:\n\n$_generatedCode';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accountability Code'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the code',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _verifyCode,
              child: const Text('Unlock'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _cancel,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}