import 'package:equatable/equatable.dart';
import 'package:order_payment/features/order_payment/domain/entities/extra_ingredient_entity.dart';

final class OrderProductEntity extends Equatable {
  OrderProductEntity({
    required this.name,
    required this.price,
    required this.count,
    List<ExtraIngredientEntity> extraIngredients = const [],
  }) : extraIngredients = List.unmodifiable(extraIngredients);

  final String name;
  final num price;
  final int count;
  final List<ExtraIngredientEntity> extraIngredients;

  num get total => price * count;

  @override
  List<Object?> get props => [name, price, count, extraIngredients];
}
