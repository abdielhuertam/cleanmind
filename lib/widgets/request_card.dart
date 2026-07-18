import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RequestCard extends StatelessWidget {
  final String userName;
  final String? title;
  final String? message;
  final IconData icon;

  final VoidCallback onApprove;
  final VoidCallback onReject;

  const RequestCard({
    super.key,
    required this.userName,
    this.title,
    this.message,
    this.icon = Icons.person,
    required this.onApprove,
    required this.onReject,
  });

@override
Widget build(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF2FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],

                    Text(
                      userName,
                      style: TextStyle(
                        fontSize:
                            title != null ? 17 : 18,
                        fontWeight:
                            FontWeight.w600,
                        color: title != null
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),

                    if (message != null) ...[
                      const SizedBox(height: 7),
                      Text(
                        message!,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.35,
                          color:
                              AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        const Divider(
          height: 1,
          thickness: 1,
        ),

        SizedBox(
          height: 62,
          child: Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(
                    Icons.check_circle_outline,
                    size: 22,
                  ),
                  label: const Text(
                    'Approve',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        AppColors.primary,
                  ),
                ),
              ),

              Container(
                width: 1,
                height: 34,
                color: Colors.black12,
              ),

              Expanded(
                child: TextButton.icon(
                  onPressed: onReject,
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 22,
                  ),
                  label: const Text(
                    'Reject',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}