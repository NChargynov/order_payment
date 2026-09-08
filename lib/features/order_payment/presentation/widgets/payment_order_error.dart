import 'package:flutter/material.dart';
import 'package:order_payment/core/theme/app_styles.dart';
import 'package:order_payment/core/theme/app_colors.dart';
import 'package:order_payment/core/widgets/app_button.dart';

class PaymentOrderError extends StatelessWidget {
  const PaymentOrderError({
    super.key,
    required this.message,
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          const Text(
            'Не удалось загрузить заказ',
            textAlign: TextAlign.center,
            style: AppStyles.title,
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: AppStyles.textSemiBold),
          const SizedBox(height: 24),
          AppButton(label: 'Повторить', onPressed: onRetry),
        ],
      ),
    ),
  );
}
