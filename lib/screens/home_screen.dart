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
      body: Builder(
        builder: (context) {
          final planState = context.watch<PlanState>();

          // 1️⃣ Protection never activated
          if (planState.lifecycle == ProtectionLifecycle.inactive) {
            return _buildInactive(planState);
          }

          // 2️⃣ Total deactivation in progress
          if (planState.isDeactivationPending) {
            return _buildDeactivationPending(planState);
          }

          // 3️⃣ Protection fully disabled
          if (planState.isProtectionDisabled) {
            return _buildProtectionDisabled(planState);
          }

          // 4️⃣ Normal protected state (existing UI)
          return _buildProtected(planState);
        },
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
            final isPro =
                 context.read<PlanState>().plan == UserPlan.premium;
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

Widget _buildInactive(PlanState planState) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your device is not protected',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: planState.activateProtection,
            child: const Text('Activate Protection'),
          ),
        ],
      ),
    ),
  );
}

Widget _buildProtected(PlanState planState) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Protection ON',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              planState.startTemporaryUnlock(
                const Duration(seconds: 10),
              );
            },
            child: const Text('Request Temporary Unlock'),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              planState.requestTotalDeactivation(
                method: DeactivationMethod.waitingPeriod,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Deactivate Protection'),
          ),
        ],
      ),
    ),
  );
}

Widget _buildDeactivationPending(PlanState planState) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Deactivation in progress',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Protection will be disabled once the selected condition is met.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget _buildProtectionDisabled(PlanState planState) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Protection Disabled',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your device is currently not protected.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: planState.reactivateProtection,
            child: const Text('Reactivate Protection'),
          ),
        ],
      ),
    ),
  );
}
