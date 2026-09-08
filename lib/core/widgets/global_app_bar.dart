import 'package:flutter/material.dart';
import 'package:order_payment/core/theme/app_colors.dart';
import 'package:order_payment/core/theme/app_styles.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    title: Text(
      title,
      style: AppStyles.titleSemiBold.copyWith(color: AppColors.textPrimary),
    ),
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.onSurface,
    surfaceTintColor: AppColors.onSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
  );
}
