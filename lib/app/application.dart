import 'package:flutter/material.dart';
import 'package:order_payment/app/di/get_it.dart';
import 'package:order_payment/core/theme/theme.dart';
import 'package:order_payment/app/router/app_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Application extends StatelessWidget {
  Application({super.key});

  final AppRouter _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: theme,
      routerConfig: _appRouter.config(
        navigatorObservers: () => [TalkerRouteObserver(getIt<Talker>())],
      ),
    );
  }
}
