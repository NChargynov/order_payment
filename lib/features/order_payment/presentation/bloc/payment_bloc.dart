import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:order_payment/core/error/app_failure.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';
import 'package:order_payment/features/order_payment/domain/use_cases/load_payment_use_case.dart';
import 'package:order_payment/features/order_payment/domain/use_cases/pay_order_use_case.dart';

import 'payment_event.dart';
import 'payment_state.dart';

@injectable
final class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(this._loadOrderUseCase, this._loadAccount, this._payOrderUseCase)
    : super(const PaymentState()) {
    on<PaymentOrderRequested>(_onOrderRequested);
    on<PaymentAccountRequested>(_onAccountRequested);
    on<PaymentMethodSelected>((event, emit) {
      if (!state.isMethodEnabled(event.method)) return;
      emit(state.copyWith(method: event.method, clearPaymentError: true));
    });
    on<PaymentPhoneChanged>((event, emit) {
      if (state.isLocked) return;
      emit(state.copyWith(phone: event.phone, clearPaymentError: true));
    });
    on<PaymentPhoneUnfocused>((event, emit) {
      if (!state.isLocked) emit(state.copyWith(showPhoneError: true));
    });
    on<PaymentSubmitted>(_onSubmitted);
    on<PaymentErrorDismissed>((event, emit) {
      if (state.paymentStatus != PaymentStatus.failure) return;
      emit(
        state.copyWith(
          paymentStatus: PaymentStatus.idle,
          clearPaymentError: true,
        ),
      );
    });
  }

  final LoadOrderUseCase _loadOrderUseCase;
  final LoadPaymentAccount _loadAccount;
  final PayOrderUseCase _payOrderUseCase;

  Future<void> _onOrderRequested(
    PaymentOrderRequested event,
    Emitter<PaymentState> emit,
  ) async {
    if (state.orderStatus == OrderStatus.loading || state.isLocked) return;
    emit(
      PaymentState(orderId: event.orderId, orderStatus: OrderStatus.loading),
    );
    try {
      final order = await _loadOrderUseCase(event.orderId);
      if (emit.isDone) return;
      emit(
        PaymentState(
          orderId: event.orderId,
          orderStatus: OrderStatus.ready,
          order: order,
        ),
      );
      if (order.availablePaymentMethods.contains(PaymentMethod.account)) {
        add(const PaymentAccountRequested());
      }
    } on AppFailure catch (error) {
      if (emit.isDone) return;
      emit(
        PaymentState(
          orderId: event.orderId,
          orderStatus: OrderStatus.failure,
          orderError: error.message,
        ),
      );
    }
  }

  Future<void> _onAccountRequested(
    PaymentAccountRequested event,
    Emitter<PaymentState> emit,
  ) async {
    final order = state.order;
    if (order == null ||
        !order.availablePaymentMethods.contains(PaymentMethod.account) ||
        state.accountStatus == AccountStatus.loading ||
        state.isLocked) {
      return;
    }
    emit(
      state.copyWith(
        accountStatus: AccountStatus.loading,
        clearAccount: true,
        clearAccountError: true,
      ),
    );
    try {
      final account = await _loadAccount();
      if (emit.isDone || !identical(order, state.order)) return;
      emit(
        state.copyWith(accountStatus: AccountStatus.ready, account: account),
      );
    } on AppFailure catch (error) {
      if (emit.isDone || !identical(order, state.order)) return;
      emit(
        state.copyWith(
          accountStatus: AccountStatus.failure,
          accountError: error.message,
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    PaymentSubmitted event,
    Emitter<PaymentState> emit,
  ) async {
    if (state.order == null || state.isLocked) return;
    if (!state.canPay) {
      emit(state.copyWith(showPhoneError: true));
      return;
    }
    final payment = state;
    emit(
      state.copyWith(
        paymentStatus: PaymentStatus.submitting,
        clearPaymentError: true,
      ),
    );
    try {
      final success = await _payOrderUseCase(
        orderId: payment.orderId,
        order: payment.order!,
        method: payment.method,
        phone: payment.phone,
        account: payment.account,
      );
      if (emit.isDone) return;
      emit(
        state.copyWith(
          paymentStatus: success ? PaymentStatus.success : PaymentStatus.failure,
          paymentError: success ? null : 'Не удалось выполнить оплату',
        ),
      );
    } on AppFailure catch (error) {
      if (emit.isDone) return;
      emit(
        state.copyWith(
          paymentStatus: PaymentStatus.failure,
          paymentError: error.message,
        ),
      );
    }
  }
}
