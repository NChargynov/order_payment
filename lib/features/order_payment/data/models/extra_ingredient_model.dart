import 'package:order_payment/core/utils/transformable.dart';
import 'package:order_payment/features/order_payment/domain/entities/extra_ingredient_entity.dart';

final class ExtraIngredientModel with Transformable<ExtraIngredientEntity> {
  const ExtraIngredientModel({
    this.ingredientName,
    this.ingredientPrice,
    this.count,
  });

  final String? ingredientName;
  final num? ingredientPrice;
  final int? count;

  factory ExtraIngredientModel.fromJson(Map<String, dynamic> json) =>
      ExtraIngredientModel(
        ingredientName: json['ingredientName'],
        ingredientPrice: json['ingredientPrice'],
        count: json['count'],
      );

  static List<ExtraIngredientModel> fromJsonList(List<dynamic> list) {
    return list
        .whereType<Map>()
        .map(
          (item) =>
              ExtraIngredientModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  @override
  ExtraIngredientEntity transform() => ExtraIngredientEntity(
    name: ingredientName ?? "",
    price: ingredientPrice ?? 0,
    count: count ?? 0,
  );
}
