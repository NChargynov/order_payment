import 'package:equatable/equatable.dart';

final class ExtraIngredientEntity extends Equatable {
  const ExtraIngredientEntity({
    required this.name,
    required this.price,
    required this.count,
  });

  final String name;
  final num price;
  final int count;

  num get total => price * count;

  @override
  List<Object?> get props => [name, price, count];
}
