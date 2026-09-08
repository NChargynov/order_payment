import 'package:order_payment/app/config/env_type.dart';
import 'package:order_payment/app/config/factory/build_configuration_from_env_impl.dart';
import 'package:order_payment/app/bootstrap.dart';

Future<void> main() async {
  final configuration = BuildConfigurationFromEnvImpl(envType: EnvType.local);
  await startApplication(configuration.instance);
}
