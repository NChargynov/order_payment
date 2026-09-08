import 'package:flutter/material.dart';
import 'package:order_payment/core/theme/app_styles.dart';
import 'package:order_payment/core/theme/app_colors.dart';
import 'package:order_payment/core/widgets/app_button.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_state.dart';

import 'money_text.dart';

class PaymentFooter extends StatelessWidget {
  const PaymentFooter({super.key, required this.state, required this.onPay});

  final PaymentState state;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final order = state.order!;
    final label = switch ((state.paymentStatus, state.method)) {
      (PaymentStatus.success, PaymentMethod.cash) => 'Заказ оформлен',
      (PaymentStatus.success, _) => 'Оплачено',
      (_, null || PaymentMethod.cash) => 'Заказать',
      _ => 'Оплатить',
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 8,
            top: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AmountLine(
                label: 'Всего товаров (${order.productCount})',
                amount: order.productsTotal,
              ),
              SizedBox(height: 2),
              _AmountLine(
                label: 'Дополнительно: ${order.ingredientCount}',
                amount: order.ingredientsTotal,
              ),
              SizedBox(height: 2),
              _AmountLine(label: 'Доставка', amount: order.deliveryCost),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 0.5, color: AppColors.border),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Итого', style: AppStyles.titleSemiBold),
                  MoneyText(
                    order.total,
                    style: AppStyles.titleSemiBold,
                    valuta: "c",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppButton(
                key: const ValueKey('pay-button'),
                label: label,
                onPressed: state.canPay ? onPay : null,
                isLoading: state.paymentStatus == PaymentStatus.submitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountLine extends StatelessWidget {
  const _AmountLine({required this.label, required this.amount});

  final String label;
  final num amount;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Text(
          label,
          style: AppStyles.smallRegular.copyWith(color: AppColors.textPrimary),
        ),
      ),
      const SizedBox(width: 8),
      MoneyText(
        amount,
        style: AppStyles.smallRegular.copyWith(color: AppColors.textPrimary),
      ),
    ],
  );
}
