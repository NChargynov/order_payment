import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:order_payment/app/router/app_router.dart';
import 'package:order_payment/app/config/build_configuration.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
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

  @LazySingleton(dispose: disposeDio)
  Dio dio(BuildConfiguration configuration, TalkerDioLogger talkerDioLogger) {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: configuration.networkConfiguration.url,
        headers: {"Content-Type": "application/json"},
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(talkerDioLogger);
    return dio;
  }

  @lazySingleton
  TalkerDioLogger talkerDioLogger(Talker talker) {
    return TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printRequestHeaders: false,
        printResponseData: true,
        printResponseMessage: true,
      ),
    );
  }
}

void disposeAppRouter(AppRouter router) => router.dispose();

void disposeDio(Dio dio) => dio.close(force: true);
