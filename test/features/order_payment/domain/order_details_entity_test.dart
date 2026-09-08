import 'package:flutter_test/flutter_test.dart';
import 'package:order_payment/features/order_payment/domain/entities/extra_ingredient_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_details_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_product_entity.dart';

void main() {
  group('OrderDetailsEntity', () {
    test('сумма учитывает количество, добавки и доставку', () {
      final order = OrderDetailsEntity(
        availablePaymentMethods: [],
        deliveryCost: 190,
        products: [
          OrderProductEntity(
            name: 'Бургер',
            price: 200,
            count: 2,
            extraIngredients: const [
              ExtraIngredientEntity(name: 'Сыр', price: 30, count: 3),
            ],
          ),
          OrderProductEntity(name: 'Картошка фри', price: 150, count: 1),
        ],
      );

      expect(order.productsTotal, 550);
      expect(order.ingredientsTotal, 90);
      expect(order.total, 830);
    });

    test('у пустого заказа в сумме остаётся только доставка', () {
      final order = OrderDetailsEntity(
        availablePaymentMethods: [],
        deliveryCost: 190,
        products: [],
      );

      expect(order.productsTotal, 0);
      expect(order.ingredientsTotal, 0);
      expect(order.total, 190);
    });

    test('дробные цены не обрезаются до целого', () {
      final order = OrderDetailsEntity(
        availablePaymentMethods: [],
        deliveryCost: 10.25,
        products: [OrderProductEntity(name: 'Напиток', price: 12.30, count: 3)],
      );

      expect(order.total, closeTo(47.15, 0.000001));
    });
  });
}
