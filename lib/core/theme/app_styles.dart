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


  static const title = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const dialogTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const productLabel = TextStyle(fontSize: 12, height: 1.3);
  static const amountLabel = TextStyle(fontSize: 12, height: 20 / 12);
  static const dialogMessage = TextStyle(fontSize: 12, height: 1.4);

  static const totalAmount = TextStyle(
    fontSize: 18,
    height: 28 / 18,
    letterSpacing: -.36,
    fontWeight: FontWeight.w600,
  );

  static const inputLabel = TextStyle(
    fontSize: 14,
    height: 16 / 14,
    letterSpacing: -.28,
    fontWeight: FontWeight.w500,
  );
  static const input = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: -.28,
    color: AppColors.textPrimary,
  );

  static const button = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -.32,
  );
  static const buttonCompact = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 4 / 3,
    letterSpacing: -.24,
  );
  static const currencySymbol = TextStyle(decoration: TextDecoration.underline);
}
