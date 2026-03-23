import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color color;
  final double size;

  const LoadingWidget({
    super.key,
    this.message,
    this.color = AppColors.primaryGold,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
