import 'package:flutter/material.dart';
import 'package:order_payment/core/theme/app_styles.dart';

class MoneyText extends StatelessWidget {
  const MoneyText(this.money, {super.key, this.style, this.valuta = "C"});

  final num money;
  final String valuta;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      text: '$money ',
      children: [TextSpan(text: valuta, style: AppStyles.currencySymbol)],
    ),
    style: style,
    semanticsLabel: '$money сом',
  );
}
