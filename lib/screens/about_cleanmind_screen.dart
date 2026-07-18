import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AboutCleanMindScreen
    extends StatelessWidget {
  const AboutCleanMindScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        backgroundColor:
            AppColors.primary,
        foregroundColor:
            Colors.white,
        title: const Text(
          'About CleanMind',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                Icons.shield,
                size: 64,
                color:
                    AppColors.primary,
              ),

              SizedBox(height: 16),

              Text(
                'CleanMind',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                  color: AppColors
                      .textPrimary,
                ),
              ),

              SizedBox(height: 24),

              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors
                      .textSecondary,
                ),
              ),

              SizedBox(height: 10),

              Text(
                'Created by [Company Name]',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors
                      .textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}