import 'package:injectable/injectable.dart';
import 'package:order_payment/features/order_payment/data/dto/payment_request_dto.dart';
import 'package:order_payment/features/order_payment/data/data_sources/interface/payment_data_source.dart';
import 'package:order_payment/features/order_payment/data/models/extra_ingredient_model.dart';
import 'package:order_payment/features/order_payment/data/models/order_details_model.dart';
import 'package:order_payment/features/order_payment/data/models/order_product_model.dart';
import 'package:order_payment/features/order_payment/data/models/payment_account_model.dart';

@LazySingleton(as: PaymentDataSource, env: ['local'])
final class LocalDataSourceImpl implements PaymentDataSource {
  const LocalDataSourceImpl({
    @ignoreParam this.delay = const Duration(milliseconds: 500),
  });

  final Duration delay;

  static const _products = [
    OrderProductModel(
      name: 'Бургер',
      price: 200,
      count: 1,
      extraIngredients: [
        ExtraIngredientModel(
          ingredientName: 'Сыр',
          count: 1,
          ingredientPrice: 30,
        ),
      ],
    ),
    OrderProductModel(name: 'Картошка фри', price: 150, count: 1),
  ];

  @override
  Future<OrderDetailsModel> getOrderDetails({required String orderId}) async {
    await Future<void>.delayed(delay);
    return const OrderDetailsModel(
      availablePaymentMethods: ['O_DENGI', 'MBANK', 'ACCOUNT', 'CASH'],
      deliveryCost: 190,
      products: _products,
    );
  }

  @override
  Future<PaymentAccountModel?> getUserAccount() async {
    await Future<void>.delayed(delay);
    return const PaymentAccountModel(id: '18182920202', balance: 3000);
  }

  @override
  Future<bool> pay({required PaymentRequestDTO dto}) async {
    await Future<void>.delayed(delay);
    return true;
  }
}
