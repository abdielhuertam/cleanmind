import 'package:flutter/material.dart';

import 'state/plan_state.dart';

import 'services/local_storage_service.dart';

import 'screens/main_shell_screen.dart';

import 'screens/copy_challenge_screen.dart';
import 'screens/accountability_code_screen.dart';
import 'screens/unlock_methods_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PlanState loadedPlan =
      await LocalStorageService.loadPlan();

  loadedPlan =
      loadedPlan.refreshLifecycle();

  await LocalStorageService.savePlan(
    loadedPlan,
  );

  runApp(
    MyApp(
      initialPlan: loadedPlan,
    ),
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

class _MyAppState
    extends State<MyApp>
    with WidgetsBindingObserver {

  late PlanState _plan;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addObserver(this);

    _plan = widget.initialPlan;
  }

  @override
  void dispose() {

    WidgetsBinding.instance
        .removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) async {

    if (state ==
        AppLifecycleState.resumed) {

      final refreshedPlan =
          _plan.refreshLifecycle();

      await LocalStorageService
          .savePlan(
        refreshedPlan,
      );

      if (!mounted) return;

      setState(() {
        _plan = refreshedPlan;
      });
    }
  }

  Future<void> _onPlanChanged(
    PlanState updatedPlan,
  ) async {

    await LocalStorageService.savePlan(
      updatedPlan,
    );

    if (!mounted) return;

    setState(() {
      _plan = updatedPlan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false,

      home: MainShellScreen(
        plan: _plan,

        onPlanChanged:
            _onPlanChanged,
      ),

      routes: {

        '/copy-challenge':
            (context) =>
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

        '/unlock-methods':
            (context) =>
                UnlockMethodsScreen(
                  plan: _plan,

                  onPlanChanged:
                      _onPlanChanged,
                ),
      },
    );
  }
}