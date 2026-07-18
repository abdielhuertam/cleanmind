import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../services/storage_service.dart';

class SupportPhoneScreen extends StatefulWidget {
  const SupportPhoneScreen({
    super.key,
  });

  @override
  State<SupportPhoneScreen> createState() =>
      _SupportPhoneScreenState();
}

class _SupportPhoneScreenState
    extends State<SupportPhoneScreen> {
  
  String _countryCode = '+52';

  final List<String> _countryCodes = [
    '+1',
    '+34',
    '+44',
    '+52',
    '+54',
    '+55',
    '+56',
    '+57',
    '+58',
  ];

  final TextEditingController
      _nameController =
      TextEditingController();

  final TextEditingController
      _phoneController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
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
        elevation: 0,
        title: const Text(
          'Add Phone Support',
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [
            const Text(
              'Add your Support',
              style: TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.bold,
                color:
                    AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Your Support will receive SMS codes to approve protection requests.',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color:
                    AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  _nameController,
              textCapitalization:
                  TextCapitalization.words,
              decoration:
                  _inputDecoration(
                label: 'Name',
                icon:
                    Icons.person_outline,
              ),
            ),

            const SizedBox(height: 12),

            Row(
            children: [
                Container(
                height: 58,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                    color: Colors.grey.shade300,
                    ),
                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                    value: _countryCode,
                    items: _countryCodes.map((code) {
                        return DropdownMenuItem<String>(
                        value: code,
                        child: Text(code),
                        );
                    }).toList(),
                    onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                        _countryCode = value;
                        });
                    },
                    ),
                ),
                ),

                const SizedBox(width: 10),

                Expanded(
                child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration(
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    ),
                ),
                ),
            ],
),

            const SizedBox(height: 18),

            Container(
              padding:
                  const EdgeInsets.all(14),

              decoration:
                  BoxDecoration(
                color: const Color(
                  0xFFE5EEFC,
                ),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Icon(
                    Icons.sms_outlined,
                    color:
                        AppColors.primary,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Verification codes will be sent by SMS. Standard messaging rates may apply.',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              height: 54,

              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.success,
                  foregroundColor:
                      Colors.white,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),
                    onPressed: () async {
                    final name =
                        _nameController.text.trim();

                    final phone =
                        _phoneController.text.trim();

                    if (name.isEmpty || phone.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                            'Enter the Support name and phone number.',
                            ),
                        ),
                        );
                        return;
                    }

                    try {
                        await StorageService.saveSupportName(name);
                        await StorageService.saveSupportPhone(
                        '$_countryCode$phone',
                        );
                        await StorageService.saveSupportType(
                        'sms',
                        );


                        if (!mounted) return;

                        await showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) {
                            return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                            ),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                const Icon(
                                    Icons.check_circle,
                                    color: AppColors.success,
                                    size: 64,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                    'Support Added',
                                    style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                    'Your Support was added successfully.',
                                    textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                    onPressed: () {
                                    Navigator.pop(dialogContext);
                                    Navigator.pop(context, true);
                                    },
                                    child: const Text('Done'),
                                    ),
                                ),
                                ],
                            ),
                            );
                        },
                        );
                    } catch (_) {
                        if (!mounted) return;

                        await showDialog<void>(
                        context: context,
                        builder: (dialogContext) {
                            return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                            ),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                const Icon(
                                    Icons.error_outline,
                                    color: AppColors.danger,
                                    size: 64,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                    'Unable to Add Support',
                                    style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                    'Something went wrong. Please check your connection and try again.',
                                    textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                    onPressed: () {
                                        Navigator.pop(dialogContext);
                                    },
                                    child: const Text('Try Again'),
                                    ),
                                ),
                                ],
                            ),
                            );
                        },
                        );
                    }
                    },

                child: const Text(
                  'Add Support',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: label,
      prefixText: prefixText,
      prefixIcon: Icon(
        icon,
        color: AppColors.primary,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
    );
  }
}