import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';

final class PaymentRequestDTO {
  const PaymentRequestDTO({
    required this.orderId,
    required this.method,
    required this.totalSum,
    this.requisite,
  });

  final String orderId;
  final PaymentMethod method;
  final num totalSum;
  final String? requisite;

  Map<String, dynamic> get toJson => {
    if (method != PaymentMethod.cash) 'requisite': requisite,
    'totalSum': totalSum,
  };
}
