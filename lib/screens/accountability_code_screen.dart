import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

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

final List<TextEditingController> _controllers =
    List.generate(
  6,
  (_) => TextEditingController(),
);

final List<FocusNode> _focusNodes =
    List.generate(
  6,
  (_) => FocusNode(),
);

  late final String _generatedCode;

  Timer? _resendTimer;

int _secondsRemaining = 180;

bool _smsSent = false;

bool get _canResend =>
    _secondsRemaining == 0;


  @override
  void initState() {
    super.initState();

    _generatedCode = '676294';
  }



  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

void _unlock() {
  final updatedPlan =
      widget.plan.unlockSucceeded();

  widget.onPlanChanged(updatedPlan);

  Navigator.pop(context); // Cierra SMS Code
  Navigator.pop(context); // Cierra Unlock Methods
}

void _startResendTimer() {

  _resendTimer?.cancel();

  _resendTimer = Timer.periodic(
    const Duration(seconds: 1),
    (_) {

      if (!mounted) return;

      if (_secondsRemaining > 0) {

        setState(() {
          _secondsRemaining--;
        });

      } else {

        _resendTimer?.cancel();

        setState(() {

          _smsSent = false;

          _secondsRemaining = 180;

          for (final controller in _controllers) {
            controller.clear();
          }

          FocusScope.of(context).unfocus();
        });
      }
    },
  );
}

void _onDigitChanged(
  int index,
  String value,
) {
  if (value.isNotEmpty &&
      index < 5) {
    _focusNodes[index + 1]
        .requestFocus();
  }

  if (value.isEmpty &&
      index > 0) {
    _focusNodes[index - 1]
        .requestFocus();
  }

  final enteredCode =
      _controllers
          .map(
            (c) => c.text,
          )
          .join();

  if (enteredCode.length == 6 &&
      enteredCode ==
          _generatedCode) {
    _unlock();
  }
}

void _onKeyPressed(
  int index,
  KeyEvent event,
) {
  if (event is! KeyDownEvent) return;

  if (event.logicalKey ==
      LogicalKeyboardKey.backspace) {

    if (_controllers[index].text.isEmpty &&
        index > 0) {

      _focusNodes[index - 1].requestFocus();

      _controllers[index - 1].clear();
    }
  }
}

Future<bool> _showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String description,
  required String warning,
  required String confirmText,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),

            title: Text(title),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(description),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.08),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Text(
                    warning,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            actions: [

              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Cancel"),
              ),

              FilledButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(confirmText),
              ),
            ],
          );
        },
      ) ??
      false;
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
                'SMS Code',

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

                    const SizedBox(height: 22),

                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      child: Row(
                        children: [

                          const Icon(
                            Icons.phone,
                            color: AppColors.primary,
                            size: 28,
                          ),

                          const SizedBox(width: 14),

                          const Expanded(
                            child: Text(
                              '+52 •••• •••• 0062',

                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 52,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _smsSent
                          ? null
                          : () async {

                            final confirmed =
                                await _showConfirmationDialog(
                              context: context,

                              title: 'Request SMS Code?',

                              description:
                                  'A verification code will be sent to your accountability contact.',

                              warning:
                                  'Protection will only disable after successful verification. Your progress streak will reset if protection is disabled.',

                              confirmText: 'Send Code',
                            );

                            if (!confirmed) {
                              return;
                            }

                            if (!mounted) {
                              return;
                            }

                            setState(() {
                              _smsSent = true;
                              _secondsRemaining = 180;

                              for (final controller in _controllers) {
                                controller.clear();
                              }
                            });

                            _resendTimer?.cancel();
                            _startResendTimer();
                            _focusNodes.first.requestFocus();
                          },
                      child: const Text(
                        'Send Code',
                      ),
                    ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Enter the received code',

                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    IgnorePointer(
                      ignoring: !_smsSent,

                      child: Opacity(
                        opacity: _smsSent ? 1 : .45,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => SizedBox(
                            width: 46,
                            height: 56,

                            child: KeyboardListener(
                              focusNode: FocusNode(),

                              onKeyEvent: (event) {
                                _onKeyPressed(
                                  index,
                                  event,
                                );
                              },

                              child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],

                              enabled: _smsSent,

                              keyboardType: TextInputType.number,

                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                              ],

                              textAlign: TextAlign.center,

                              maxLength: 1,

                              decoration: InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.zero,

                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),

                              onChanged: (value) {
                                if (value.length > 1) {
                                  value = value.substring(0, 1);
                                  _controllers[index].text = value;
                                  _controllers[index].selection =
                                      TextSelection.collapsed(
                                    offset: value.length,
                                  );
                                }

                                _onDigitChanged(
                                  index,
                                  value,
                                );
                              },
                            ),
                            ),
                          ),
                        ),
                    ),
                    ),
                    ),

                    const SizedBox(height: 24),

                    if (_smsSent)
                      TextButton(
                      onPressed: _canResend
                          ? () {
                              setState(() {
                                _smsSent = true;
                                _secondsRemaining = 180;

                                for (final controller in _controllers) {
                                  controller.clear();
                                }

                                _focusNodes.first.requestFocus();
                              });

                              _startResendTimer();
                            }
                          : null,

                      child: Text(
                        _canResend
                            ? 'Resend Code'
                            : 'Resend Code (${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')})',
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.06),
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Row(
                        children: [

                          const Icon(
                            Icons.info_outline,
                            size: 18,
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              _smsSent
                                  ? 'The verification code expires in ${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}.'
                                  : 'Press "Send Code" to receive a verification code.',
                            ),
                          ),
                        ],
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