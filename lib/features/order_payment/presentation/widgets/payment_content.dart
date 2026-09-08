import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payment/core/theme/app_styles.dart';
import 'package:order_payment/core/widgets/app_card.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_bloc.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_event.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_state.dart';

import 'money_text.dart';
import 'order_products_card.dart';
import 'payment_method_sheet.dart';
import 'payment_method_tile.dart';
import 'payment_phone_field.dart';

class PaymentContent extends StatelessWidget {
  const PaymentContent({super.key, required this.state});

  final PaymentState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PaymentBloc>();
    final order = state.order!;
    final noMethods = order.availablePaymentMethods.isEmpty;

    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      children: [
        AppCard(
          padding: EdgeInsets.symmetric(
            horizontal: state.method == PaymentMethod.account ? 16 : 8,
            vertical: state.method == PaymentMethod.account ? 8 : 4,
          ),
          child: PaymentMethodTile(
            key: const ValueKey('payment-method-selector'),
            method: state.method,
            emptyLabel: noMethods
                ? 'Нет доступных методов оплаты'
                : 'Выберите метод оплаты',
            subtitle:
                state.method == PaymentMethod.account && state.account != null
                ? MoneyText(state.account!.balance, style: AppStyles.smallSemiBold)
                : null,
            onTap: state.isLocked || noMethods
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    showPaymentMethodSheet(context);
                  },
          ),
        ),
        const SizedBox(height: 8),
        if (state.method?.requiresPhone ?? false) ...[
          PaymentPhoneField(
            phone: state.phone,
            errorText: state.phoneError,
            enabled: !state.isLocked,
            onChanged: (phone) => bloc.add(PaymentPhoneChanged(phone)),
            onUnfocused: () => bloc.add(const PaymentPhoneUnfocused()),
          ),
          const SizedBox(height: 8),
        ],
        OrderProductsCard(products: order.products),
      ],
    );
  }
}
