import 'package:flutter/material.dart';

import '../state/plan_state.dart';
import '../theme/app_colors.dart';

class AccountabilityCodeScreen
    extends StatefulWidget {
  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

  const AccountabilityCodeScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  State<AccountabilityCodeScreen>
      createState() =>
          _AccountabilityCodeScreenState();
}

class _AccountabilityCodeScreenState
    extends State<AccountabilityCodeScreen> {
  final TextEditingController _controller =
      TextEditingController();

  late final String _generatedCode;

  bool get _isCorrect =>
      _controller.text.trim() ==
      _generatedCode;

  @override
  void initState() {
    super.initState();

    _generatedCode = '676294';

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
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
                'Verification Code',

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
                      Icons.sms,
                      size: 60,
                      color: AppColors.primary,
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'A verification code was sent to your Support.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(22),

                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withOpacity(0.08),

                        borderRadius:
                            BorderRadius.circular(24),
                      ),

                      child: Column(
                        children: const [
                          Text(
                            'Ask your Support for the verification code sent to',

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontSize: 15,
                              height: 1.4,
                              color:
                                  AppColors
                                      .textSecondary,
                            ),
                          ),

                          SizedBox(height: 14),

                          Text(
                            '+52 •••• •••• 0062',

                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    TextField(
                      controller: _controller,

                      keyboardType:
                          TextInputType.number,

                      decoration: InputDecoration(
                        hintText:
                            'Enter verification code',

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
                          'Verify & Unlock',

                          style: TextStyle(
                            fontSize: 18,
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