import 'package:order_payment/features/order_payment/domain/entities/order_details_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_account_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';
import 'package:order_payment/features/order_payment/domain/validation/payment_validation.dart';

enum OrderStatus { initial, loading, ready, failure }

enum AccountStatus { initial, loading, ready, failure }

enum PaymentStatus { idle, submitting, success, failure }

final class PaymentState {
  const PaymentState({
    this.orderId = '',
    this.orderStatus = OrderStatus.initial,
    this.accountStatus = AccountStatus.initial,
    this.paymentStatus = PaymentStatus.idle,
    this.order,
    this.account,
    this.method,
    this.phone = '996',
    this.showPhoneError = false,
    this.orderError,
    this.accountError,
    this.paymentError,
  });

  final String orderId;
  final OrderStatus orderStatus;
  final AccountStatus accountStatus;
  final PaymentStatus paymentStatus;
  final OrderDetailsEntity? order;
  final PaymentAccountEntity? account;
  final PaymentMethod? method;
  final String phone;
  final bool showPhoneError;
  final String? orderError;
  final String? accountError;
  final String? paymentError;

  bool get isLocked =>
      paymentStatus == PaymentStatus.submitting ||
      paymentStatus == PaymentStatus.success;

  bool get canPay {
    final order = this.order;
    if (order == null || isLocked) return false;
    return validatePayment(
          order: order,
          method: method,
          phone: phone,
          account: account,
        ) ==
        null;
  }

  String? get phoneError => showPhoneError && (method?.requiresPhone ?? false)
      ? validatePaymentPhone(phone)
      : null;

  String? get accountUnavailableReason => switch (accountStatus) {
    AccountStatus.initial || AccountStatus.loading => 'Загрузка баланса…',
    AccountStatus.failure => accountError ?? 'Не удалось загрузить баланс',
    AccountStatus.ready => validatePayment(
      order: order!,
      method: PaymentMethod.account,
      phone: phone,
      account: account,
    )?.message,
  };

  bool isMethodEnabled(PaymentMethod method) =>
      !isLocked &&
      (order?.availablePaymentMethods.contains(method) ?? false) &&
      (method != PaymentMethod.account || accountUnavailableReason == null);

  PaymentState copyWith({
    AccountStatus? accountStatus,
    PaymentStatus? paymentStatus,
    PaymentAccountEntity? account,
    PaymentMethod? method,
    String? phone,
    bool? showPhoneError,
    String? accountError,
    String? paymentError,
    bool clearAccount = false,
    bool clearAccountError = false,
    bool clearPaymentError = false,
  }) => PaymentState(
    orderId: orderId,
    orderStatus: orderStatus,
    order: order,
    orderError: orderError,
    accountStatus: accountStatus ?? this.accountStatus,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    account: clearAccount ? null : account ?? this.account,
    method: method ?? this.method,
    phone: phone ?? this.phone,
    showPhoneError: showPhoneError ?? this.showPhoneError,
    accountError: clearAccountError ? null : accountError ?? this.accountError,
    paymentError: clearPaymentError ? null : paymentError ?? this.paymentError,
  );
}
