import 'package:flutter/material.dart';
import 'package:order_payment/core/theme/app_colors.dart';

final ThemeData theme = ThemeData(
  fontFamily: 'Inter',
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontFamily: 'Inter',
      color: AppColors.textPrimary,
      letterSpacing: -0.2,
    ),
  ),
  appBarTheme: const AppBarThemeData(backgroundColor: AppColors.onSurface),
);
