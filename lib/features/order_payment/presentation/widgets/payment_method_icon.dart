import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';
import 'package:order_payment/gen/assets.gen.dart';

class PaymentMethodIcon extends StatelessWidget {
  const PaymentMethodIcon(this.method, {super.key});
  final PaymentMethod method;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: 24,
      child: switch (method) {
        PaymentMethod.account => SvgPicture.asset(Assets.icons.icUser),
        PaymentMethod.cash => SvgPicture.asset(Assets.icons.icCash),
        PaymentMethod.mbank => Image.asset(Assets.images.mbank.path),
        PaymentMethod.oDengi => ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(Assets.images.odengi.path),
        ),
      },
    ),
  );
}
