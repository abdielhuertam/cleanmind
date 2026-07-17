import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../theme/app_colors.dart';

import '../state/plan_state.dart';

import '../services/protection_service.dart';

import '../widgets/protection_status_overlay.dart';


class CustomDurationScreen extends StatefulWidget {

  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

  const CustomDurationScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
  });

  @override
  State<CustomDurationScreen> createState() =>
      _CustomDurationScreenState();
}

class _CustomDurationScreenState
    extends State<CustomDurationScreen> {

  int _selectedDays = 0;
  int _selectedHours = 0;
  int _selectedMinutes = 5;



  Duration get duration {
    return Duration(
      days: _selectedDays,
      hours: _selectedHours,
      minutes: _selectedMinutes,
    );
  }

bool get isValid =>
    duration.inSeconds >= 295;

bool get showPermanentSuggestion =>
    _selectedDays >= 7;




 String get durationText {

  final roundedMinutes =
      (duration.inSeconds / 60)
          .ceil();

  if (roundedMinutes < 60) {
    return '$roundedMinutes minutes';
  }

  final hours =
      duration.inHours;

  final remaining =
      duration.inMinutes % 60;

  if (hours < 24) {
    return '$hours h $remaining m';
  }

  final days =
      duration.inDays;

  return '$days days';
}

  Widget _numberPicker({
    required String label,
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [

              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  icon: const Icon(Icons.remove),
                onPressed:
                    value > min
                        ? () => onChanged(value - 1)
                        : null,
              ),
              ),

              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  icon: const Icon(Icons.add),
                onPressed:
                    value < max
                        ? () => onChanged(value + 1)
                        : null,
              ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
          'Custom Duration',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [

            const SizedBox(
              height: 20,
            ),

            const Text(
              'Choose how long you want to stay focused',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Row(
              children: [

                Expanded(
                  child: _numberPicker(
                    label: 'Days',
                    value: _selectedDays,
                    min: 0,
                    max: 7,
                    onChanged: (value) {
                      setState(() {
                        _selectedDays = value;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _numberPicker(
                    label: 'Hours',
                    value: _selectedHours,
                    min: 0,
                    max: 23,
                    onChanged: (value) {
                      setState(() {
                        _selectedHours = value;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _numberPicker(
                    label: 'Minutes',
                    value: _selectedMinutes,
                    min: 5,
                    max: 59,
                    onChanged: (value) {
                      setState(() {
                        _selectedMinutes = value;
                      });
                    },
                  ),
                ),

              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    const Text(
                      'Selected Duration',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      'Minimum: 5 min',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Text(
                      durationText,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isValid) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'Protection will start when you tap "Start Focus Session" and will automatically end after the selected duration.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Protection duration must be at least 5 minutes.',
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (showPermanentSuggestion)
              Card(
                color:
                    Colors.green.shade50,
                child: const Padding(
                  padding:
                      EdgeInsets.all(
                    16,
                  ),
                  child: Text(
                    'Planning a longer commitment?\n\nIf you plan to stay protected for several days or longer, Permanent Protection is recommended. It offers full rewards, medal progression, and a stronger commitment experience.',
                  ),
                ),
              ),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.success,
                foregroundColor:
                    Colors.white,
              ),
          onPressed:
              isValid
                  ? () async {

                      final updatedPlan =
                          await ProtectionService.activatePartialProtection(
                        plan: widget.plan,
                        expiresAt: DateTime.now().add(
                          duration,
                        ),
                      );

                      widget.onPlanChanged(
                        updatedPlan,
                      );

                      await ProtectionStatusOverlay.showActivated(
                        context,
                      );

                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  : null,
              child: const Text(
                'Start Focus Session',
              ),
            ),
          ],
        ),
      ),
    );
  }
}