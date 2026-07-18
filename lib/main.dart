import 'package:flutter/material.dart';

import 'state/plan_state.dart';

import 'services/local_storage_service.dart';
import 'services/notification_service.dart';
import 'services/local_user_profile_repository.dart';
import 'services/user_profile_repository.dart';

import 'screens/main_shell_screen.dart';
import 'screens/copy_challenge_screen.dart';
import 'screens/accountability_code_screen.dart';
import 'screens/unlock_methods_screen.dart';
import 'screens/protection_mode_selection_screen.dart';

import 'theme/app_colors.dart';

import 'models/user_profile.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();

  
  final repository =
      userProfileRepository;

  final existingProfile =
      await repository.getProfile();

  if (existingProfile == null) {
    await repository.saveProfile(
      const UserProfile(
        userId: 'local-test-user',
        firstName: 'Abdiel',
        lastName: 'Huerta',
        username: '@abdielhuerta',
        email: 'abdiel.huertam@gmail.com',
      ),
    );
  }

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
  int _selectedIndex = 0;

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

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                AppColors.primary
          ),
        ),

        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.primary,
            foregroundColor:
                Colors.white,
          ),
        ),

        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
        ),
      ),

      home: MainShellScreen(
        plan: _plan,
        onPlanChanged: _onPlanChanged,
        selectedIndex: _selectedIndex,
        onTabChanged: _onTabChanged,
      ),

      routes: {

        '/protection-mode':
            (context) =>
                ProtectionModeSelectionScreen(
                  plan: _plan,
                  onPlanChanged:
                      _onPlanChanged,
                ),

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