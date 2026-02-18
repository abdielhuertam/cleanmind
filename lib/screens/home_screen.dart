import 'dart:async';
import 'package:flutter/material.dart';
import '../state/plan_state.dart';
import '../state/protection_state.dart';
import 'copy_challenge_screen.dart';
import 'accountability_code_screen.dart';

class HomeScreen extends StatefulWidget {
  final PlanState plan;
  final ValueChanged<PlanState> onPlanChanged;

  const HomeScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.plan.protection.status;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CleanMind'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusLabel(status),
            const SizedBox(height: 12),
            _buildProgressInfo(status),
            const SizedBox(height: 32),
            _buildPrimaryAction(context, status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusLabel(ProtectionStatus status) {
    switch (status) {
      case ProtectionStatus.active:
        return const Text(
          'Protection is ON',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        );
      case ProtectionStatus.protectionDisabled:
      case ProtectionStatus.inactive:
        return const Text(
          'Protection is OFF',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        );
      case ProtectionStatus.deactivationPending:
        return const Text(
          'Unlock in progress',
          style: TextStyle(fontSize: 18),
        );
    }
  }

  Widget _buildProgressInfo(ProtectionStatus status) {
    if (status != ProtectionStatus.active) {
      return const SizedBox();
    }

    final duration = widget.plan.protection.getActiveDuration();
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    return Text(
      'Protected for: $days day(s) $hours hour(s) $minutes minute(s)',
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildPrimaryAction(BuildContext context, ProtectionStatus status) {
  switch (status) {
    case ProtectionStatus.active:
      return Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final updatedPlan = widget.plan.requestUnlock();
              widget.onPlanChanged(updatedPlan);
              Navigator.pushNamed(context, '/copy-challenge');
            },
            child: const Text('Copy Challenge'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final updatedPlan = widget.plan.requestUnlock();
              widget.onPlanChanged(updatedPlan);
              Navigator.pushNamed(context, '/accountability-code');
            },
            child: const Text('Accountability Code'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () {
              _showDeactivationDialog(context);
            },
            child: const Text('Deactivate Protection (8-hour waiting period)'),
          ),
        ],
      );

    case ProtectionStatus.deactivationPending:
      final remaining =
          widget.plan.protection.getRemainingDeactivationTime();

      return Column(
        children: [
          const Text(
            'Deactivation scheduled',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (remaining != null)
            Text(
              'Time remaining: ${remaining.inHours}h '
              '${remaining.inMinutes.remainder(60)}m',
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
            onPressed: () {
              final updatedPlan =
                  widget.plan.cancelDeactivation();
              widget.onPlanChanged(updatedPlan);
            },
            child: const Text('Cancel Deactivation'),
          ),
        ],
      );

    case ProtectionStatus.protectionDisabled:
    case ProtectionStatus.inactive:
      return ElevatedButton(
        onPressed: () {
          widget.onPlanChanged(widget.plan.manualReactivate());
        },
        child: const Text('Activate Protection'),
      );
  }
}


  Future<bool> _showUnlockWarning(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Unlock'),
        content: const Text(
          'If you continue, your progress counter will reset.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

    void _showDeactivationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Deactivation'),
        content: const Text(
          'If you continue, your progress will reset after 8 hours. '
          'Your accountability partner will be notified when protection is disabled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final updatedPlan =
                  widget.plan.requestDeactivation();
              widget.onPlanChanged(updatedPlan);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}