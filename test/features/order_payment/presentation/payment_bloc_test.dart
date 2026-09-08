import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_payment/core/error/app_failure.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_details_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_product_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_account_entity.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_request_entity.dart';
import 'package:order_payment/features/order_payment/domain/repositories/payment_repository.dart';
import 'package:order_payment/features/order_payment/domain/use_cases/load_payment_use_case.dart';
import 'package:order_payment/features/order_payment/domain/use_cases/pay_order_use_case.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_bloc.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_event.dart';
import 'package:order_payment/features/order_payment/presentation/bloc/payment_state.dart';

void main() {
  late _PaymentRepository repository;
  late PaymentBloc bloc;

  setUp(() async {
    repository = _PaymentRepository();
    bloc = PaymentBloc(
      LoadOrderUseCase(repository),
      LoadPaymentAccount(repository),
      PayOrderUseCase(repository),
    );
    addTearDown(bloc.close);

    final loaded = bloc.stream.firstWhere(
      (state) => state.orderStatus == OrderStatus.ready,
    );
    bloc.add(const PaymentOrderRequested('1'));
    await loaded;

    final selected = bloc.stream.firstWhere(
      (state) => state.method == PaymentMethod.cash,
    );
    bloc.add(const PaymentMethodSelected(PaymentMethod.cash));
    await selected;
  });

  test('успешная оплата проходит через submitting в success', () async {
    final states = expectLater(
      bloc.stream.map((state) => state.paymentStatus),
      emitsInOrder([PaymentStatus.submitting, PaymentStatus.success]),
    );

    bloc.add(const PaymentSubmitted());
    await states;

    expect(bloc.state.paymentError, isNull);
    expect(bloc.state.canPay, isFalse);
  });

  test('ответ false переводит оплату в failure', () async {
    repository.paymentResult = const Right(false);
    final states = expectLater(
      bloc.stream.map((state) => state.paymentStatus),
      emitsInOrder([PaymentStatus.submitting, PaymentStatus.failure]),
    );

    bloc.add(const PaymentSubmitted());
    await states;

    expect(bloc.state.paymentError, 'Не удалось выполнить оплату');
  });

  test('сообщение об ошибке репозитория попадает в state', () async {
    repository.paymentResult = const Left(
      AppFailure('Сервис оплаты временно недоступен'),
    );
    final states = expectLater(
      bloc.stream.map((state) => state.paymentStatus),
      emitsInOrder([PaymentStatus.submitting, PaymentStatus.failure]),
    );

    bloc.add(const PaymentSubmitted());
    await states;

    expect(bloc.state.paymentError, 'Сервис оплаты временно недоступен');
  });
}

class _PaymentRepository implements PaymentRepository {
  Either<AppFailure, bool> paymentResult = const Right(true);

  @override
  Future<Either<AppFailure, OrderDetailsEntity>> getOrderDetails({
    required String orderId,
  }) async => Right(
    OrderDetailsEntity(
      availablePaymentMethods: [PaymentMethod.cash],
      deliveryCost: 190,
      products: [OrderProductEntity(name: 'Бургер', price: 200, count: 1)],
    ),
  );

  @override
  Future<Either<AppFailure, PaymentAccountEntity?>> getUserAccount() async =>
      const Right(null);

  @override
  Future<Either<AppFailure, bool>> pay({
    required PaymentRequestEntity request,
  }) async => paymentResult;
}
