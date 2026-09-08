import 'package:order_payment/features/order_payment/domain/entities/order_details_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_account_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';
import 'package:order_payment/features/order_payment/domain/failures/payment_failure.dart';

String? validatePaymentPhone(String phone) {
  if (phone.isEmpty) return 'Введите номер телефона';
  if (!RegExp(r'^996[0-9]{9}$').hasMatch(phone)) {
    return 'Номер должен начинаться с 996 и содержать 12 цифр';
  }
  return null;
}

PaymentFailure? validatePayment({
  required OrderDetailsEntity order,
  required PaymentMethod? method,
  required String phone,
  required PaymentAccountEntity? account,
}) {
  if (method == null || !order.availablePaymentMethods.contains(method)) {
    return const PaymentFailure('Выберите доступный метод оплаты');
  }
  if (method.requiresPhone) {
    final error = validatePaymentPhone(phone);
    if (error != null) return PaymentFailure(error);
  }
  if (method == PaymentMethod.account) {
    if (account == null) {
      return const PaymentFailure('Аккаунт отсутствует');
    }
    if (account.balance < order.total) {
      return const PaymentFailure('Недостаточно средств на балансе');
    }
  }
  return null;
}
