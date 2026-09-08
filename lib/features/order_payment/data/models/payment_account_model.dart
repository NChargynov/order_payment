import 'package:order_payment/core/utils/transformable.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_account_entity.dart';

final class PaymentAccountModel with Transformable<PaymentAccountEntity> {
  const PaymentAccountModel({this.id, this.balance});

  final String? id;
  final num? balance;

  factory PaymentAccountModel.fromJson(Map<String, dynamic> json) =>
      PaymentAccountModel(id: json['id'], balance: json['balance']);

  @override
  PaymentAccountEntity transform() =>
      PaymentAccountEntity(id: id ?? '', balance: balance ?? 0);
}
