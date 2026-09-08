import 'package:order_payment/core/contracts/dependency.dart';
import 'package:order_payment/features/order_payment/data/dto/payment_request_dto.dart';
import 'package:order_payment/features/order_payment/data/models/order_details_model.dart';
import 'package:order_payment/features/order_payment/data/models/payment_account_model.dart';

abstract interface class PaymentDataSource implements DataSource {
  Future<OrderDetailsModel> getOrderDetails({required String orderId});

  Future<PaymentAccountModel?> getUserAccount();

  Future<bool> pay({required PaymentRequestDTO dto});
}
