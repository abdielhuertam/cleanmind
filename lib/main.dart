import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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

import 'widgets/celebration_overlay.dart';
import 'state/celebration_state.dart';

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

  if (kDebugMode && loadedPlan.xp < 999) {
    loadedPlan = loadedPlan.copyWith(
      xp: 999,
    );
  }

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

  final GlobalKey<NavigatorState>
      _navigatorKey =
          GlobalKey<NavigatorState>();

  bool _showingCelebration = false;

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

  Future<void> _showCelebrationIfNeeded() async {
    if (_showingCelebration) return;

    if (!_plan.celebration.isPending) return;

    final context = _navigatorKey.currentContext;

    if (context == null) return;

    _showingCelebration = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: CelebrationOverlay(
            celebration: _plan.celebration,
            onContinue: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );

    _showingCelebration = false;

    final clearedPlan = _plan.copyWith(
      celebration: CelebrationState.none(),
    );

    await LocalStorageService.savePlan(
      clearedPlan,
    );

    if (!mounted) return;

    setState(() {
      _plan = clearedPlan;
    });
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCelebrationIfNeeded();
    });
  }

  void _triggerDebugCelebration() {
    final updatedPlan = _plan.copyWith(
      celebration: const CelebrationState(
        isPending: true,
        type: CelebrationType.levelUp,
        title: 'Debug Celebration',
        message: 'This is a test celebration.',
        level: 99,
      ),
    );

    _onPlanChanged(updatedPlan);
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
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

      home: Stack(
        children: [
          MainShellScreen(
            plan: _plan,
            onPlanChanged: _onPlanChanged,
            selectedIndex: _selectedIndex,
            onTabChanged: _onTabChanged,
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              mini: true,
              onPressed: _triggerDebugCelebration,
              child: const Icon(Icons.celebration),
            ),
          ),
        ],
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