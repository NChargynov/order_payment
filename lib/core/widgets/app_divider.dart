import 'package:flutter/material.dart';
import 'package:order_payment/core/theme/app_colors.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.height = 1,
    this.thickness = 1,
    this.color = AppColors.border,
  });

  final EdgeInsetsGeometry padding;
  final double height;
  final double? thickness;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Divider(height: height, thickness: thickness, color: color),
  );
}
