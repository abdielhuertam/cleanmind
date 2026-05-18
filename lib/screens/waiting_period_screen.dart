import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class WaitingPeriodScreen
    extends StatefulWidget {
  const WaitingPeriodScreen({
    super.key,
  });

  @override
  State<WaitingPeriodScreen>
      createState() =>
          _WaitingPeriodScreenState();
}

class _WaitingPeriodScreenState
    extends State<
      WaitingPeriodScreen
    > {
  bool _customDateMode =
      false;

  String _selectedPreset =
      '24 Hours';

  DateTime? _customDate;

  final List<_PresetOption>
  _presetOptions = [
    _PresetOption(
      label: '1 Hour',
      premium: true,
    ),

    _PresetOption(
      label: '2 Hours',
      premium: true,
    ),

    _PresetOption(
      label: '4 Hours',
      premium: true,
    ),

    _PresetOption(
      label: '8 Hours',
    ),

    _PresetOption(
      label: '12 Hours',
    ),

    _PresetOption(
      label: '24 Hours',
    ),

    _PresetOption(
      label: '7 Days',
    ),

    _PresetOption(
      label: '30 Days',
    ),

    _PresetOption(
      label: '90 Days',
    ),

    _PresetOption(
      label: '120 Days',
    ),

    _PresetOption(
      label: '1 Year',
    ),
  ];

  Future<void> _pickCustomDate()
  async {
    final now =
        DateTime.now();

    final minimum =
        now.add(
      const Duration(hours: 24),
    );

    final pickedDate =
        await showDatePicker(
      context: context,

      initialDate: minimum,

      firstDate: minimum,

      lastDate: DateTime(
        now.year + 5,
      ),
    );

    if (pickedDate == null) {
      return;
    }

    if (!mounted) return;

    final pickedTime =
        await showTimePicker(
      context: context,

      initialTime:
          TimeOfDay.now(),
    );

    if (pickedTime == null) {
      return;
    }

    final finalDate =
        DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final normalizedMinimum =
        DateTime(
      minimum.year,
      minimum.month,
      minimum.day,
      minimum.hour,
      minimum.minute,
    );

    final normalizedSelected =
        DateTime(
      finalDate.year,
      finalDate.month,
      finalDate.day,
      finalDate.hour,
      finalDate.minute,
    );

    if (normalizedSelected
        .isBefore(
      normalizedMinimum,
    )) {
      if (!mounted) return;

      showDialog(
        context: context,

        builder: (_) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                24,
              ),
            ),

            title: const Text(
              'Invalid Date',
            ),

            content: const Text(
              'Custom waiting periods must be at least 24 hours in the future.',
            ),

            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },

                child: const Text(
                  'OK',
                ),
              ),
            ],
          );
        },
      );

      return;
    }

    setState(() {
      _customDate = finalDate;
    });
  }

  String _formattedDate() {
    if (_customDate == null) {
      return 'No date selected';
    }

    final date =
        _customDate!;

    final month =
        [
          '',
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ][date.month];

    final hour =
        date.hour > 12
            ? date.hour - 12
            : date.hour;

    final minute =
        date.minute
            .toString()
            .padLeft(2, '0');

    final period =
        date.hour >= 12
            ? 'PM'
            : 'AM';

    return '$month ${date.day}, ${date.year} at $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),

          child: Column(
            children: [
              Container(
                height: 42,

                decoration:
                    const BoxDecoration(
                  color:
                      AppColors.primary,

                  borderRadius:
                      BorderRadius.only(
                    bottomLeft:
                        Radius.circular(
                      22,
                    ),

                    bottomRight:
                        Radius.circular(
                      22,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },

                    icon: const Icon(
                      Icons.arrow_back_ios,

                      color:
                          AppColors
                              .primary,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Waiting Period',

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        fontSize: 30,
                        fontWeight:
                            FontWeight.bold,

                        color:
                            AppColors
                                .primary,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 48,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Container(
                padding:
                    const EdgeInsets.all(
                  8,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Expanded(
                      child:
                          GestureDetector(
                        onTap: () {
                          setState(() {
                            _customDateMode =
                                false;
                          });
                        },

                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            vertical:
                                14,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                !_customDateMode
                                    ? AppColors.primary
                                    : Colors.transparent,

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),

                          child: Text(
                            'Predefined',

                            textAlign:
                                TextAlign.center,

                            style: TextStyle(
                              fontSize:
                                  17,

                              fontWeight:
                                  FontWeight.bold,

                              color:
                                  !_customDateMode
                                      ? Colors.white
                                      : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child:
                          GestureDetector(
                        onTap: () {
                          setState(() {
                            _customDateMode =
                                true;
                          });
                        },

                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            vertical:
                                14,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                _customDateMode
                                    ? AppColors.primary
                                    : Colors.transparent,

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),

                          child: Text(
                            'Custom Date',

                            textAlign:
                                TextAlign.center,

                            style: TextStyle(
                              fontSize:
                                  17,

                              fontWeight:
                                  FontWeight.bold,

                              color:
                                  _customDateMode
                                      ? Colors.white
                                      : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child:
                    !_customDateMode
                        ? _buildPresetMode()
                        : _buildCustomDateMode(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetMode() {
    return GridView.builder(
      itemCount:
          _presetOptions.length,

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,

        crossAxisSpacing: 14,

        mainAxisSpacing: 14,

        childAspectRatio: 2.2,
      ),

      itemBuilder: (
        context,
        index,
      ) {
        final option =
            _presetOptions[index];

        final selected =
            _selectedPreset ==
                option.label;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPreset =
                  option.label;
            });
          },

          child: Container(
            decoration: BoxDecoration(
              color:
                  selected
                      ? AppColors.primary
                      : Colors.white,

              borderRadius:
                  BorderRadius.circular(
                24,
              ),

              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: Stack(
              children: [
                if (option.premium)
                  Positioned(
                    top: 10,
                    right: 10,

                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.orange,

                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: const Text(
                        'PRO',

                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,

                          color:
                              Colors.white,
                        ),
                      ),
                    ),
                  ),

                Center(
                  child: Text(
                    option.label,

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      fontSize: 18,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          selected
                              ? Colors.white
                              : AppColors
                                  .textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomDateMode() {
    return Column(
      children: [
        Container(
          width: double.infinity,

          padding:
              const EdgeInsets.all(
            28,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              30,
            ),

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
                Icons.event,

                size: 64,

                color:
                    AppColors.primary,
              ),

              const SizedBox(height: 22),

              Text(
                _formattedDate(),

                textAlign:
                    TextAlign.center,

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Custom dates must be at least 24 hours in the future.',

                textAlign:
                    TextAlign.center,

                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,

                  color:
                      AppColors
                          .textSecondary,
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,

                height: 56,

                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,

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
                      _pickCustomDate,

                  child: const Text(
                    'Choose Date & Time',

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
      ],
    );
  }
}

class _PresetOption {
  final String label;

  final bool premium;

  const _PresetOption({
    required this.label,
    this.premium = false,
  });
}