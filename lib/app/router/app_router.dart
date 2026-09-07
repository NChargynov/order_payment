import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:order_payment/app/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType =>
      Platform.isIOS ? RouteType.cupertino() : RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: OrderPaymentRoute.page, initial: true),
  ];
}
