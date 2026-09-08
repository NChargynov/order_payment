import 'package:injectable/injectable.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_details_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_account_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_request_entity.dart';
import 'package:order_payment/features/order_payment/domain/repositories/payment_repository.dart';
import 'package:order_payment/features/order_payment/domain/validation/payment_validation.dart';

@injectable
final class PayOrderUseCase {
  const PayOrderUseCase(this._repository);
  final PaymentRepository _repository;

  Future<bool> call({
    required String orderId,
    required OrderDetailsEntity order,
    required PaymentMethod? method,
    required String phone,
    required PaymentAccountEntity? account,
  }) async {
    final error = validatePayment(
      order: order,
      method: method,
      phone: phone,
      account: account,
    );
    if (error != null) throw error;

    final result = await _repository.pay(
      request: PaymentRequestEntity(
        orderId: orderId,
        method: method!,
        totalSum: order.total,
        requisite: switch (method) {
          PaymentMethod.mbank || PaymentMethod.oDengi => phone,
          PaymentMethod.account => account!.id,
          PaymentMethod.cash => null,
        },
      ),
    );
    return result.fold((failure) => throw failure, (success) => success);
  }
}
