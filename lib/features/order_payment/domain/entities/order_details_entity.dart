import 'package:equatable/equatable.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_product_entity.dart';

import 'payment_method.dart';

final class OrderDetailsEntity extends Equatable {
  OrderDetailsEntity({
    required List<PaymentMethod> availablePaymentMethods,
    required this.deliveryCost,
    required List<OrderProductEntity> products,
  }) : availablePaymentMethods = List.unmodifiable(availablePaymentMethods),
       products = List.unmodifiable(products);

  final List<PaymentMethod> availablePaymentMethods;
  final num deliveryCost;
  final List<OrderProductEntity> products;

  int get productCount =>
      products.fold(0, (sum, product) => sum + product.count);

  int get ingredientCount => products
      .expand((product) => product.extraIngredients)
      .fold(0, (count, ingredient) => count + ingredient.count);

  num get productsTotal =>
      products.fold<num>(0, (sum, product) => sum + product.total);

  num get ingredientsTotal => products
      .expand((product) => product.extraIngredients)
      .fold<num>(0, (total, ingredient) => total + ingredient.total);

  num get total => productsTotal + ingredientsTotal + deliveryCost;

  @override
  List<Object?> get props => [availablePaymentMethods, deliveryCost, products];
}
