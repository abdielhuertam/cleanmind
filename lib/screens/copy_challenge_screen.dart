import 'dart:async';
import 'package:flutter/material.dart';
import '../state/plan_state.dart';

class CopyChallengeScreen extends StatefulWidget {
  final PlanState plan;
  final ValueChanged<PlanState> onPlanChanged;

  const CopyChallengeScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  State<CopyChallengeScreen> createState() => _CopyChallengeScreenState();
}

class _CopyChallengeScreenState extends State<CopyChallengeScreen> {
  static const int totalSeconds = 30;
  static const String challengeText =
      'I choose clarity over impulse.';

  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  int _remainingSeconds = totalSeconds;
  bool _expired = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        _onTimeExpired();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _cancel() {
    _timer.cancel();
    widget.onPlanChanged(widget.plan.manualReactivate());
    Navigator.of(context).pop();
  }

  void _onTimeExpired() async {
    setState(() {
      _expired = true;
    });

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Time Expired'),
        content: const Text(
          'You did not complete the challenge in time.\n\nProtection remains active.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    widget.onPlanChanged(widget.plan.manualReactivate());
    Navigator.of(context).pop();
  }

  void _onSuccess() {
    _timer.cancel();
    widget.onPlanChanged(widget.plan.unlockSucceeded());
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = _controller.text.trim() == challengeText;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Copy Challenge'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_remainingSeconds seconds remaining',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Text(
              challengeText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type the sentence exactly',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isCorrect && !_expired ? _onSuccess : null,
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
