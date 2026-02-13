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
              onPressed: () async {
                final confirmed = await _showUnlockWarning(context);
                if (!confirmed) return;

                final updatedPlan = widget.plan.requestUnlock();
                widget.onPlanChanged(updatedPlan);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CopyChallengeScreen(
                      plan: updatedPlan,
                      onPlanChanged: widget.onPlanChanged,
                    ),
                  ),
                );
              },
              child: const Text('Copy Challenge'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final confirmed = await _showUnlockWarning(context);
                if (!confirmed) return;

                final updatedPlan = widget.plan.requestUnlock();
                widget.onPlanChanged(updatedPlan);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AccountabilityCodeScreen(
                      plan: updatedPlan,
                      onPlanChanged: widget.onPlanChanged,
                    ),
                  ),
                );
              },
              child: const Text('Accountability Code'),
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

      case ProtectionStatus.deactivationPending:
        return const CircularProgressIndicator();
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
}