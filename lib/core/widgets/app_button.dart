import 'package:flutter/material.dart';
import 'package:order_payment/core/theme/app_styles.dart';

import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.color = AppColors.primary,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) => Semantics(
    label: isLoading ? '$label. Выполняется' : null,
    child: SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.onSurface,
          disabledBackgroundColor: isLoading ? color : AppColors.border,
          disabledForegroundColor: AppColors.onSurface,
          minimumSize: Size(0, compact ? 32 : 48),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: compact ? 8 : 12,
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: compact ? AppStyles.smallMedium : AppStyles.textMedium,
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onSurface,
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                style: AppStyles.textMedium,
              ),
      ),
    ),
  );
}
