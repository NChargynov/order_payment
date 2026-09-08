import 'package:order_payment/core/utils/transformable.dart';
import 'package:order_payment/features/order_payment/data/models/order_product_model.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_details_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';


final class OrderDetailsModel with Transformable<OrderDetailsEntity> {
  const OrderDetailsModel({
    this.availablePaymentMethods,
    this.deliveryCost,
    this.products,
  });

  final List<String>? availablePaymentMethods;
  final num? deliveryCost;
  final List<OrderProductModel>? products;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        availablePaymentMethods: json['availablePaymentMethods'] == null
            ? null
            : List<String>.from(json['availablePaymentMethods'] as List),
        deliveryCost: json['deliveryCost'],
        products: OrderProductModel.fromJsonList(json['products']),
      );

  @override
  OrderDetailsEntity transform() => OrderDetailsEntity(
    availablePaymentMethods:
        availablePaymentMethods
            ?.map(
              (method) => switch (method) {
                'O_DENGI' => PaymentMethod.oDengi,
                'MBANK' => PaymentMethod.mbank,
                'ACCOUNT' => PaymentMethod.account,
                'CASH' => PaymentMethod.cash,
                _ => throw const FormatException('Неизвестный метод оплаты'),
              },
            )
            .toSet()
            .toList() ??
        [],
    deliveryCost: deliveryCost ?? 0,
    products: products?.transform() ?? [],
  );
}
