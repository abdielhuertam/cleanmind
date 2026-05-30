import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../state/plan_state.dart';

class PermanentProtectionConfirmationScreen
    extends StatelessWidget {

  final PlanState plan;

  final ValueChanged<PlanState>
      onPlanChanged;

  const PermanentProtectionConfirmationScreen({
    super.key,
    required this.plan,
    required this.onPlanChanged,
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
          'Permanent Protection',
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          24,
        ),

        child: Column(
          children: [

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(
                20,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  24,
                ),

                boxShadow: const [
                  BoxShadow(
                    color:
                        Colors.black12,

                    blurRadius: 8,

                    offset:
                        Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                children: [

                  const Icon(
                    Icons.shield,
                    size: 44,
                    color:
                        AppColors.primary,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  const Text(
                    'Permanent Protection',

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          AppColors.primary,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  _item(
                    'Content blocking enabled',
                  ),

                  _item(
                    'Full XP rewards',
                  ),

                  _item(
                    'Medal progression enabled',
                  ),

                  _item(
                    'Ranking progression enabled',
                  ),

                  _item(
                    'Can only be disabled through an unlock method',
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width: double.infinity,

              height: 54,

              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,

                  foregroundColor:
                      Colors.white,
                ),

                onPressed: () {

                  final updatedPlan =
                      plan.manualReactivate();

                  onPlanChanged(
                    updatedPlan,
                  );

                  Navigator.popUntil(
                    context,
                    (route) =>
                        route.isFirst,
                  );
                },

                child: const Text(
                  'Activate Protection',
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            SizedBox(
              width: double.infinity,

              height: 54,

              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },

                child: const Text(
                  'Cancel',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String text) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),

      child: Row(
        children: [

          const Icon(
            Icons.check_circle,
            size: 18,
            color: Colors.green,
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}