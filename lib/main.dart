import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/protection_state.dart';
import 'screens/home_screen.dart';
import 'state/plan_state.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProtectionState()),
        ChangeNotifierProvider(create: (_) => PlanState()),
      ],
      child: const CleanMindApp(),
    ),
  );
}

class CleanMindApp extends StatelessWidget {
  const CleanMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CleanMind',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}