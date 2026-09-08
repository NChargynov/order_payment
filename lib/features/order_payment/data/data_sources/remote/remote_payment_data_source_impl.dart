import 'package:injectable/injectable.dart';
import 'package:order_payment/core/network/api_exception.dart';
import 'package:order_payment/core/network/internal_api.dart';
import 'package:order_payment/features/order_payment/data/dto/payment_request_dto.dart';
import 'package:order_payment/features/order_payment/data/data_sources/interface/payment_data_source.dart';
import 'package:order_payment/features/order_payment/data/models/order_details_model.dart';
import 'package:order_payment/features/order_payment/data/models/payment_account_model.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';

abstract final class _ApiPath {
  static String order(String orderId) => 'order/details/$orderId';
  static const account = 'user/account';

  static String payment(PaymentRequestDTO dto) {
    final method = switch (dto.method) {
      PaymentMethod.mbank => 'mbank',
      PaymentMethod.oDengi => 'odengi',
      PaymentMethod.account => 'account',
      PaymentMethod.cash => 'cash',
    };
    return 'order-payment/by-$method/${Uri.encodeComponent(dto.orderId)}';
  }
}

@LazySingleton(as: PaymentDataSource, env: ['development'])
final class RemoteDataSourceImpl implements PaymentDataSource {
  const RemoteDataSourceImpl({required this.api});

  final InternalApi api;

  @override
  Future<OrderDetailsModel> getOrderDetails({required String orderId}) async {
    final response = await api.get(_ApiPath.order(orderId));
    return OrderDetailsModel.fromJson(response.data);
  }

  @override
  Future<PaymentAccountModel?> getUserAccount() async {
    final response = await api.get(_ApiPath.account);
    final data = response.data as Map<String, dynamic>;
    final message = data['message'];
    if (data['id'] == null && data['balance'] == null && message is String) {
      throw ApiException(message);
    }
    return PaymentAccountModel.fromJson(data);
  }

  @override
  Future<bool> pay({required PaymentRequestDTO dto}) async {
    final response = await api.post(_ApiPath.payment(dto), data: dto.toJson);
    return response.statusCode == 200;
  }
}
