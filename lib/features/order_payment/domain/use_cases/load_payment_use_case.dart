import 'package:injectable/injectable.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_details_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_account_entity.dart';
import 'package:order_payment/features/order_payment/domain/repositories/payment_repository.dart';

@injectable
final class LoadOrderUseCase {
  const LoadOrderUseCase(this._repository);

  final PaymentRepository _repository;

  Future<OrderDetailsEntity> call(String orderId) async {
    final result = await _repository.getOrderDetails(orderId: orderId);
    return result.fold((failure) => throw failure, (model) => model);
  }
}

@injectable
final class LoadPaymentAccount {
  const LoadPaymentAccount(this._repository);

  final PaymentRepository _repository;

  Future<PaymentAccountEntity?> call() async {
    final result = await _repository.getUserAccount();
    return result.fold((failure) => throw failure, (model) => model);
  }
}
