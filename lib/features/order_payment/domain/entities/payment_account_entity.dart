import 'package:equatable/equatable.dart';

final class PaymentAccountEntity extends Equatable {
  const PaymentAccountEntity({required this.id, required this.balance});

  final String id;
  final num balance;

  @override
  List<Object?> get props => [id, balance];
}
