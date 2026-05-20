import 'dart:async';

import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../theme/app_colors.dart';

class CopyChallengeScreen extends StatefulWidget {
  final PlanState plan;

  final ValueChanged<PlanState> onPlanChanged;

  const CopyChallengeScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  State<CopyChallengeScreen> createState() =>
      _CopyChallengeScreenState();
}

class _CopyChallengeScreenState
    extends State<CopyChallengeScreen> {
  static const _requiredText =
      'I choose clarity over impulse.';

  final TextEditingController _controller =
      TextEditingController();

  Timer? _timer;

  int _secondsRemaining = 25;

  bool get _isCorrect =>
      _controller.text.trim() == _requiredText;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        if (_secondsRemaining <= 1) {
          _timer?.cancel();

          Navigator.pop(context);
          return;
        }

        setState(() {
          _secondsRemaining--;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();

    super.dispose();
  }

  void _unlock() {
    final updatedPlan =
        widget.plan.unlockSucceeded();

    widget.onPlanChanged(updatedPlan);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            20,
            24,
            36,
          ),

          child: Column(
            children: [
              Container(
                height: 24,

                decoration: const BoxDecoration(
                  color: AppColors.primary,

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Copy Challenge',

                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(30),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    const Icon(
                      Icons.edit_note,
                      size: 60,
                      color: AppColors.primary,
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withOpacity(0.08),

                        borderRadius:
                            BorderRadius.circular(18),
                      ),

                      child: Text(
                        '$_secondsRemaining seconds remaining',

                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Type the sentence exactly as shown below.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,

                        borderRadius:
                            BorderRadius.circular(22),
                      ),

                      child: const Text(
                        _requiredText,

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:
                              AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _controller,

                      decoration: InputDecoration(
                        hintText:
                            'Type the sentence exactly',

                        filled: true,

                        fillColor: Colors.white,

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor: _isCorrect
                              ? AppColors.primary
                              : AppColors.disabled,

                          foregroundColor:
                              Colors.white,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),
                        ),

                        onPressed:
                            _isCorrect ? _unlock : null,

                        child: const Text(
                          'Unlock',

                          style: TextStyle(
                            fontSize: 19,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text(
                  'Cancel',

                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}