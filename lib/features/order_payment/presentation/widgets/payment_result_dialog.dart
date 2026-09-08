import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:order_payment/core/theme/app_styles.dart';
import 'package:order_payment/core/theme/app_colors.dart';
import 'package:order_payment/core/widgets/app_button.dart';
import 'package:order_payment/gen/assets.gen.dart';

class PaymentResultDialog extends StatelessWidget {
  const PaymentResultDialog({
    super.key,
    required this.title,
    required this.message,
    this.isSuccess = false,
  });

  final String title;
  final String message;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? AppColors.success : AppColors.error;
    return Dialog(
      constraints: const BoxConstraints(maxWidth: 263),
      backgroundColor: AppColors.onSurface,
      surfaceTintColor: AppColors.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSuccess
                ? const Icon(
                    Icons.check_circle_outline,
                    size: 88,
                    color: AppColors.success,
                  )
                : SvgPicture.asset(Assets.icons.icErrorPay),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.titleSemiBold.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.smallRegular,
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Ок',
              compact: true,
              color: color,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
