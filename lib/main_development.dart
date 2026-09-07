import 'package:order_payment/core/config/env_type.dart';
import 'package:order_payment/core/config/factory/build_configuration_from_env_impl.dart';
import 'package:order_payment/app/bootstrap.dart';

Future<void> main() async {
  final configuration = BuildConfigurationFromEnvImpl(
    envType: EnvType.development,
  );
  await startApplication(configuration.instance);
}
