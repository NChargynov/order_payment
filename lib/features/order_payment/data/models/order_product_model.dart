import 'package:order_payment/core/utils/transformable.dart';
import 'package:order_payment/features/order_payment/data/models/extra_ingredient_model.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_product_entity.dart';


final class OrderProductModel with Transformable<OrderProductEntity> {
  const OrderProductModel({
    this.name,
    this.price,
    this.count,
    this.extraIngredients = const [],
  });

  final String? name;
  final num? price;
  final int? count;
  final List<ExtraIngredientModel>? extraIngredients;

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      OrderProductModel(
        name: json['name'],
        price: json['price'],
        count: json['count'],
        extraIngredients: ExtraIngredientModel.fromJsonList(
          (json['extraIngredients'] as List<dynamic>?) ?? const [],
        ),
      );

  static List<OrderProductModel> fromJsonList(List<dynamic> list) {
    return list
        .whereType<Map>()
        .map(
          (item) => OrderProductModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  @override
  OrderProductEntity transform() => OrderProductEntity(
    name: name ?? "",
    price: price ?? 0,
    count: count ?? 0,
    extraIngredients: extraIngredients?.transform() ?? [],
  );
}
