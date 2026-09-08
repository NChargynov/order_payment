import 'package:flutter/material.dart';
import 'package:order_payment/core/theme/app_colors.dart';

abstract final class AppStyles {
  static const titleSemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
  );

  static const textSemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
  );

  static const smallSemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
  );

  static const textMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w500,
  );

  static const smallMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w500,
  );

  static const smallRegular = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w400,
    color: AppColors.textSoft,
    height: 16 / 12,
  );
  static const currencySymbol = TextStyle(decoration: TextDecoration.underline);
}
