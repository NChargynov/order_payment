import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:order_payment/app/di/get_it.dart';
import 'package:order_payment/core/config/build_configuration.dart';
import 'package:order_payment/core/config/env_type.dart';

@RoutePage()
class OrderPaymentPage extends StatelessWidget {
  const OrderPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final environment = getIt<BuildConfiguration>().type;
    final buildTypeLabel = switch (environment) {
      EnvType.local => 'local',
      EnvType.development => 'dev',
    };

    return Scaffold(body: Center(child: Text(buildTypeLabel)));
  }
}
