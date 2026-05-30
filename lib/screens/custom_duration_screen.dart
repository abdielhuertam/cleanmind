import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../theme/app_colors.dart';

import '../state/plan_state.dart';
import 'partial_protection_confirmation_screen.dart';

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

  late DateTime _endDateTime;

  @override
  void initState() {
    super.initState();

      _endDateTime = DateTime.now().add(
        const Duration(minutes: 5),
      );
  }

  Duration get duration {
    final now = DateTime.now();

    final diff =
        _endDateTime.difference(
      now,
    );

    if (diff.isNegative) {
      return Duration.zero;
    }

    return diff;
  }

bool get isValid =>
    duration.inSeconds >= 295;

  bool get showPermanentSuggestion =>
      duration.inHours > 24;

  Future<void> _pickDate() async {

    final minimumDate =
        DateTime.now().add(
      const Duration(
        minutes: 5,
      ),
    );

    final date =
        await showDatePicker(
      context: context,
      initialDate:
          _endDateTime,
      firstDate:
          minimumDate,
      lastDate:
          DateTime.now().add(
        const Duration(
          days: 365,
        ),
      ),
    );

    if (date == null) return;
    setState(() {

      _endDateTime =
          DateTime(
        date.year,
        date.month,
        date.day,
        _endDateTime.hour,
        _endDateTime.minute,
      );

      final minimum =
          DateTime.now().add(
        const Duration(
          minutes: 5,
        ),
      );

      if (_endDateTime.isBefore(
        minimum,
      )) {

        _endDateTime =
            minimum;
      }
    });
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _endDateTime,
      ),
    );

    if (time == null) return;

    setState(() {
      _endDateTime = DateTime(
        _endDateTime.year,
        _endDateTime.month,
        _endDateTime.day,
        time.hour,
        time.minute,
      );
    });
  }

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
              height: 20,
            ),

            const SizedBox(
              height: 12,
            ),

            InkWell(
              onTap: () async {
                await _pickDate();

                if (!mounted) return;

                await _pickTime();
              },

              borderRadius:
                  BorderRadius.circular(
                18,
              ),

              child: Container(
                padding:
                    const EdgeInsets.all(
                  16,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(
                        0,
                        3,
                      ),
                    ),
                  ],
                ),

                child: Row(
                  children: [

                    const Icon(
                      Icons.schedule,
                      color:
                          AppColors.primary,
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Text(
                        '${_endDateTime.day}/${_endDateTime.month}/${_endDateTime.year} • ${TimeOfDay.fromDateTime(_endDateTime).format(context)}',

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color:
                          AppColors.primary,
                    ),
                  ],
                ),
              ),
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
                      'Your Focus Session',
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
            if (!isValid)
              const Padding(
                padding:
                    EdgeInsets.only(
                  top: 12,
                ),
                child: Text(
                  'Protection duration must be at least 5 minutes.',
                ),
              ),

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
                    'Planning a longer commitment?\n\nIf you are planning to stay focused for more than a day, Permanent Protection may be a better fit and will help you earn more rewards as you progress.',
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
                      ? () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                    PartialProtectionConfirmationScreen(
                                      plan: widget.plan,
                                      onPlanChanged:
                                          widget.onPlanChanged,
                                      selectedDuration:
                                          duration,
                                    ),
                            ),
                          );
                        }
        : null,
              child: const Text(
                'Activate Partial Protection',
              ),
            ),
          ],
        ),
      ),
    );
  }
}