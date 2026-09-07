import 'package:order_payment/core/config/build_configuration.dart';
import 'package:order_payment/core/config/env_type.dart';

abstract class BuildConfigurationFromEnv {
  const BuildConfigurationFromEnv({required this.envType});

  final EnvType envType;

  BuildConfiguration get instance;
}
