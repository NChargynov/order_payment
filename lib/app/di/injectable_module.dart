import 'package:injectable/injectable.dart';
import 'package:order_payment/app/router/app_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

@module
abstract class InjectableModule {
  @LazySingleton(dispose: disposeAppRouter)
  AppRouter appRouter() => AppRouter();

  @lazySingleton
  Talker talker() => TalkerFlutter.init(
    settings: TalkerSettings(
      maxHistoryItems: 30,
      titles: {TalkerKey.exception.toString(): 'Error: '},
      enabled: true,
    ),
  );
}

void disposeAppRouter(AppRouter router) => router.dispose();
