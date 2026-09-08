import 'package:fpdart/fpdart.dart';
import 'package:order_payment/core/error/app_failure.dart';
import 'package:order_payment/core/contracts/dependency.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_details_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_account_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_request_entity.dart';

abstract interface class PaymentRepository implements Repository {
  Future<Either<AppFailure, OrderDetailsEntity>> getOrderDetails({
    required String orderId,
  });

  Future<Either<AppFailure, PaymentAccountEntity?>> getUserAccount();

  Future<Either<AppFailure, bool>> pay({required PaymentRequestEntity request});
}
