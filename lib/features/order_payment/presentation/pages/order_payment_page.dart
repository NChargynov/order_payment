import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payment/app/di/get_it.dart';
import 'package:order_payment/core/theme/app_colors.dart';
import 'package:order_payment/core/widgets/global_app_bar.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_bloc.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_event.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_state.dart';
import 'package:order_payment/features/order_payment/presentation/widgets/payment_content.dart';
import 'package:order_payment/features/order_payment/presentation/widgets/payment_footer.dart';
import 'package:order_payment/features/order_payment/presentation/widgets/payment_order_error.dart';
import 'package:order_payment/features/order_payment/presentation/widgets/payment_result_dialog.dart';

@RoutePage()
class OrderPaymentPage extends StatelessWidget {
  const OrderPaymentPage({super.key, this.orderId = '1'});

  final String orderId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<PaymentBloc>()..add(PaymentOrderRequested(orderId)),
    child: const _PaymentView(),
  );
}

class _PaymentView extends StatelessWidget {
  const _PaymentView();

  Future<void> _showResult(BuildContext context, PaymentState state) async {
    final bloc = context.read<PaymentBloc>();
    final success = state.paymentStatus == PaymentStatus.success;
    final (title, message) = switch ((success, state.method)) {
      (false, _) => (
        'Ошибка оплаты',
        state.paymentError ?? 'Не удалось выполнить оплату',
      ),
      (true, PaymentMethod.cash) => (
        'Заказ оформлен',
        'Оплатите заказ наличными при получении',
      ),
      (true, _) => ('Оплата прошла успешно', 'Заказ №${state.orderId} оплачен'),
    };
    await showDialog<void>(
      context: context,
      barrierColor: AppColors.barrier,
      builder: (_) => PaymentResultDialog(
        isSuccess: success,
        title: title,
        message: message,
      ),
    );
    if (!bloc.isClosed && !success) bloc.add(const PaymentErrorDismissed());
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<PaymentBloc, PaymentState>(
    listenWhen: (previous, current) =>
        previous.paymentStatus != current.paymentStatus &&
        (current.paymentStatus == PaymentStatus.failure ||
            current.paymentStatus == PaymentStatus.success),
    listener: _showResult,
    builder: (context, state) => PopScope(
      canPop: state.paymentStatus != PaymentStatus.submitting,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: const GlobalAppBar(title: 'Оплата заказа'),
        body: switch (state.orderStatus) {
          OrderStatus.initial || OrderStatus.loading => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              semanticsLabel: 'Загрузка заказа',
            ),
          ),
          OrderStatus.failure => PaymentOrderError(
            message: state.orderError ?? 'Не удалось загрузить заказ',
            onRetry: () => context.read<PaymentBloc>().add(
              PaymentOrderRequested(state.orderId),
            ),
          ),
          OrderStatus.ready => Column(
            children: [
              Expanded(child: PaymentContent(state: state)),
              PaymentFooter(
                state: state,
                onPay: () =>
                    context.read<PaymentBloc>().add(const PaymentSubmitted()),
              ),
            ],
          ),
        },
      ),
    ),
  );
}
