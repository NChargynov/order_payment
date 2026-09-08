import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:order_payment/core/error/app_failure.dart';
import 'package:order_payment/core/error/error_mapper.dart';
import 'package:order_payment/features/order_payment/data/dto/payment_request_dto.dart';
import 'package:order_payment/features/order_payment/data/data_sources/interface/payment_data_source.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_details_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_account_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_request_entity.dart';
import 'package:order_payment/features/order_payment/domain/repositories/payment_repository.dart';

@LazySingleton(as: PaymentRepository)
final class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl({required this.dataSource});

  final PaymentDataSource dataSource;

  @override
  Future<Either<AppFailure, OrderDetailsEntity>> getOrderDetails({
    required String orderId,
  }) async {
    try {
      final entity = await dataSource.getOrderDetails(orderId: orderId);
      return Right(entity.transform());
    } catch (e) {
      return Left(mapException(e));
    }
  }

  @override
  Future<Either<AppFailure, PaymentAccountEntity?>> getUserAccount() async {
    try {
      final entity = await dataSource.getUserAccount();
      return Right(entity?.transform());
    } catch (e) {
      return Left(mapException(e));
    }
  }

  @override
  Future<Either<AppFailure, bool>> pay({
    required PaymentRequestEntity request,
  }) async {
    try {
      final result = await dataSource.pay(
        dto: PaymentRequestDTO(
          orderId: request.orderId,
          method: request.method,
          totalSum: request.totalSum,
          requisite: request.requisite,
        ),
      );
      return Right(result);
    } catch (e) {
      return Left(mapException(e));
    }
  }
}
