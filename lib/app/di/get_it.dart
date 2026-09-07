import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:order_payment/app/di/get_it.config.dart';
import 'package:order_payment/core/config/env_type.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies({required EnvType environment}) async {
  await Future.sync(() => getIt.init(environment: environment.name));
}
