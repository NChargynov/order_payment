import 'payment_method.dart';

final class PaymentRequestEntity {
  const PaymentRequestEntity({
    required this.orderId,
    required this.method,
    required this.totalSum,
    this.requisite,
  });

  final String orderId;
  final PaymentMethod method;
  final num totalSum;
  final String? requisite;
}
