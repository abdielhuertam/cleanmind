import 'package:flutter/material.dart';
import 'state/plan_state.dart';
import 'screens/home_screen.dart';
import 'services/local_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CleanMindApp());
}

class CleanMindApp extends StatefulWidget {
  const CleanMindApp({super.key});

  @override
  State<CleanMindApp> createState() => _CleanMindAppState();
}

class _CleanMindAppState extends State<CleanMindApp> {
  PlanState? _plan;

  @override
  void initState() {
    super.initState();
    _initializePlan();
  }

  Future<void> _initializePlan() async {
    final loadedPlan = await LocalStorageService.loadPlan();

    print("Loaded status: ${loadedPlan.protection.status}");
    print("Loaded activatedAt: ${loadedPlan.protection.activatedAt}");

    setState(() {
      _plan = loadedPlan;
    });
  }

  Future<void> _updatePlan(PlanState newPlan) async {
    await LocalStorageService.savePlan(newPlan);

    setState(() {
      _plan = newPlan;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_plan == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        plan: _plan!,
        onPlanChanged: _updatePlan,
      ),
    );
  }
}