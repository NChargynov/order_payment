import 'package:flutter/material.dart';
import 'package:order_payment/core/theme/app_styles.dart';
import 'package:order_payment/core/theme/app_colors.dart';
import 'package:order_payment/features/order_payment/domain/entities/order_product_entity.dart';

import 'money_text.dart';

class OrderProductsCard extends StatelessWidget {
  const OrderProductsCard({super.key, required this.products});

  final List<OrderProductEntity> products;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: AppColors.onSurface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Продукты', style: AppStyles.textSemiBold),
        ),
        if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: Text(
              'В заказе пока нет товаров',
              style: AppStyles.textSemiBold.copyWith(color: AppColors.textSecondary),
            ),
          ),
        Column(
          children: products
              .map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _ProductTile(product: product),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final OrderProductEntity product;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        _ProductLine(
          name: product.name,
          count: product.count,
          total: product.total,
        ),
        for (final ingredient in product.extraIngredients) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Divider(height: 1, thickness: 1, color: AppColors.border),
          ),
          _ProductLine(
            name: 'Дополнительно: ${ingredient.name}',
            count: ingredient.count,
            total: ingredient.total,
          ),
        ],
      ],
    ),
  );
}

class _ProductLine extends StatelessWidget {
  const _ProductLine({
    required this.name,
    required this.count,
    required this.total,
  });

  final String name;
  final int count;
  final num total;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppStyles.smallMedium),
              Text('$count шт', style: AppStyles.smallRegular),
            ],
          ),
        ),
        const SizedBox(width: 12),
        MoneyText(total, style: AppStyles.smallMedium),
      ],
    ),
  );
}
