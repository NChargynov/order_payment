import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:order_payment/core/theme/app_styles.dart';
import 'package:order_payment/core/theme/app_colors.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_bloc.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_event.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_state.dart';
import 'package:order_payment/gen/assets.gen.dart';

import 'money_text.dart';
import 'payment_method_tile.dart';

Future<void> showPaymentMethodSheet(BuildContext context) {
  final bloc = context.read<PaymentBloc>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.onSurface,
    barrierColor: AppColors.barrier,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) =>
        BlocProvider.value(value: bloc, child: const PaymentMethodSheet()),
  );
}

class PaymentMethodSheet extends StatelessWidget {
  const PaymentMethodSheet({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: SingleChildScrollView(
      padding: const EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 8),
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          final methods = const [
            PaymentMethod.account,
            PaymentMethod.mbank,
            PaymentMethod.oDengi,
            PaymentMethod.cash,
          ].where(state.order!.availablePaymentMethods.contains).toList();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Метод оплаты',
                        style: AppStyles.titleSemiBold.copyWith(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Закрыть',
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 24,
                        height: 24,
                      ),
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: SvgPicture.asset(Assets.icons.icClose),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, thickness: 1, color: AppColors.gray),
              ),
              for (final method in methods) ...[
                PaymentMethodTile(
                  key: ValueKey('method-${method.name}'),
                  method: method,
                  showRadio: true,
                  selected: state.method == method,
                  subtitle: method == PaymentMethod.account
                      ? _AccountSubtitle(state: state)
                      : null,
                  onTap: state.isMethodEnabled(method)
                      ? () {
                          context.read<PaymentBloc>().add(
                            PaymentMethodSelected(method),
                          );
                          Navigator.of(context).pop();
                        }
                      : null,
                ),
                if (method != methods.last)
                  SizedBox(height: method == PaymentMethod.account ? 8 : 4),
              ],
              if (state.accountStatus == AccountStatus.failure)
                TextButton(
                  onPressed: () => context.read<PaymentBloc>().add(
                    const PaymentAccountRequested(),
                  ),
                  child: const Text('Повторить загрузку баланса'),
                ),
            ],
          );
        },
      ),
    ),
  );
}

class _AccountSubtitle extends StatelessWidget {
  const _AccountSubtitle({required this.state});

  final PaymentState state;

  @override
  Widget build(BuildContext context) {
    final reason = state.accountUnavailableReason;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.account != null)
          MoneyText(state.account!.balance, style: AppStyles.smallMedium),
        if (reason != null)
          Text(
            reason,
            style: AppStyles.smallSemiBold.copyWith(
              fontSize: 11,
              color:
                  state.accountStatus == AccountStatus.loading ||
                      state.accountStatus == AccountStatus.initial
                  ? AppColors.textSecondary
                  : AppColors.error,
            ),
          ),
      ],
    );
  }
}
