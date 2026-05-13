import 'package:flutter/material.dart';

import 'state/plan_state.dart';
import 'services/local_storage_service.dart';
import 'state/protection_state.dart';

import 'screens/main_shell_screen.dart';

import 'screens/copy_challenge_screen.dart';
import 'screens/accountability_code_screen.dart';
import 'screens/unlock_methods_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PlanState loadedPlan =
      await LocalStorageService.loadPlan();

  if (loadedPlan.protection.status ==
          ProtectionStatus.waitingPeriod &&
      loadedPlan.protection
          .isDeactivationExpired()) {
    loadedPlan =
        loadedPlan.unlockSucceeded();

    await LocalStorageService.savePlan(
      loadedPlan,
    );
  }

  runApp(
    MyApp(initialPlan: loadedPlan),
  );
}

class MyApp extends StatefulWidget {
  final PlanState initialPlan;

  const MyApp({
    super.key,
    required this.initialPlan,
  });

  @override
  State<MyApp> createState() =>
      _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late PlanState _plan;

  @override
  void initState() {
    super.initState();
    _plan = widget.initialPlan;
  }

  void _onPlanChanged(
    PlanState updatedPlan,
  ) async {
    await LocalStorageService.savePlan(
      updatedPlan,
    );

    setState(() {
      _plan = updatedPlan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: MainShellScreen(
        plan: _plan,
        onPlanChanged:
            _onPlanChanged,
      ),

      routes: {
        '/copy-challenge': (context) =>
            CopyChallengeScreen(
              plan: _plan,
              onPlanChanged:
                  _onPlanChanged,
            ),

        '/accountability-code':
            (context) =>
                AccountabilityCodeScreen(
                  plan: _plan,
                  onPlanChanged:
                      _onPlanChanged,
                ),

        '/unlock-methods': (context) =>
            UnlockMethodsScreen(
              plan: _plan,
              onPlanChanged:
                  _onPlanChanged,
            ),
      },
    );
  }
}