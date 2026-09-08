import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_payment/core/theme/app_styles.dart';

class MoneyText extends StatelessWidget {
  const MoneyText(this.money, {super.key, this.style, this.valuta = "C"});

  static final _format = NumberFormat('#,##0.##', 'ru_RU');

  final num money;
  final String valuta;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final amount = _format.format(money);
    return Text.rich(
      TextSpan(
        text: '$amount ',
        children: [TextSpan(text: valuta, style: AppStyles.currencySymbol)],
      ),
      style: style,
      semanticsLabel: '$amount сом',
    );
  }
}
