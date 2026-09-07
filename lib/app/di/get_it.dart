import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:order_payment/app/di/get_it.config.dart';
import 'package:order_payment/core/config/build_configuration.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(ignoreUnregisteredTypes: [BuildConfiguration])
Future<void> configureDependencies({
  required BuildConfiguration configuration,
}) async {
  getIt.registerSingleton<BuildConfiguration>(configuration);

  await Future.sync(() => getIt.init(environment: configuration.type.name));
}
