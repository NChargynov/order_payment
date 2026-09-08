import 'package:flutter/material.dart';
import 'package:order_payment/core/theme/app_colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.padding, required this.child});

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: AppColors.onSurface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );
}
