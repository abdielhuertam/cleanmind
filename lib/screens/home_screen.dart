import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/protection_state.dart';
import '../state/plan_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final protectionState = context.watch<ProtectionState>();

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
            _StatusLabel(protectionState: protectionState),
            const SizedBox(height: 16),
            _Countdown(protectionState: protectionState),
            const SizedBox(height: 24),
            _ExplanationText(protectionState: protectionState),
            const SizedBox(height: 40),
            _PrimaryActionButton(protectionState: protectionState),
          ],
        ),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final ProtectionState protectionState;

  const _StatusLabel({required this.protectionState});

  @override
  Widget build(BuildContext context) {
    final status = protectionState.status;

    String label;
    Color color;

    switch (status) {
      case ProtectionStatus.protectionOn:
        label = 'Protection ON';
        color = Colors.green;
        break;
      case ProtectionStatus.temporaryUnlockActive:
        label = 'Temporary Unlock Active';
        color = Colors.orange;
        break;
      case ProtectionStatus.protectionOffError:
        label = 'Protection OFF';
        color = Colors.red;
        break;
    }

    return Text(
      label,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class _Countdown extends StatelessWidget {
  final ProtectionState protectionState;

  const _Countdown({required this.protectionState});

  @override
  Widget build(BuildContext context) {
    if (protectionState.status != ProtectionStatus.temporaryUnlockActive) {
      return const SizedBox.shrink();
    }

    final d = protectionState.remainingUnlock;
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');

    return Text(
      '$h:$m:$s',
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
    );
  }
}

class _ExplanationText extends StatelessWidget {
  final ProtectionState protectionState;

  const _ExplanationText({required this.protectionState});

  @override
  Widget build(BuildContext context) {
    String text;

    switch (protectionState.status) {
      case ProtectionStatus.protectionOn:
        text = 'Protection is active. Blocked content cannot be accessed.';
        break;
      case ProtectionStatus.temporaryUnlockActive:
        text = 'Protection will be restored automatically when the timer ends.';
        break;
      case ProtectionStatus.protectionOffError:
        text =
            'Protection is currently disabled. VPN must be enabled for CleanMind to work.';
        break;
    }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final ProtectionState protectionState;

  const _PrimaryActionButton({required this.protectionState});

  @override
  Widget build(BuildContext context) {
    switch (protectionState.status) {
      case ProtectionStatus.protectionOn:
        return ElevatedButton(
          onPressed: () {
            final isPro = context.read<PlanState>().isPro;
            protectionState.requestTemporaryUnlock(isProUser: isPro);
          },
          child: const Text('Request Temporary Unlock'),
        );

      case ProtectionStatus.temporaryUnlockActive:
        return const SizedBox.shrink();

      case ProtectionStatus.protectionOffError:
        return ElevatedButton(
          onPressed: () {
            protectionState.enableProtectionFromError();
          },
          child: const Text('Enable Protection'),
        );
    }
  }
}