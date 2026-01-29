import 'package:flutter/material.dart';
import 'block_config_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
            onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (_) => const BlockConfigScreen(),
                ),
            );
            },

          child: Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'Iniciar\nBloqueo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}