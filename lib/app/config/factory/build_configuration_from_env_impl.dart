import 'package:order_payment/app/config/build_configuration.dart';
import 'package:order_payment/app/config/env_type.dart';
import 'package:order_payment/app/config/network_configuration.dart';
import 'package:order_payment/app/config/network_scheme.dart';
import 'package:order_payment/app/config/factory/build_configuration_from_env.dart';

final class BuildConfigurationFromEnvImpl implements BuildConfigurationFromEnv {
  BuildConfigurationFromEnvImpl({required this.envType});

  @override
  final EnvType envType;

  @override
  BuildConfiguration get instance => switch (envType) {
    EnvType.development => BuildConfiguration(
      type: envType,
      networkConfiguration: const NetworkConfiguration(
        host: 'payment.free.beeceptor.com', // dev url
        scheme: NetworkScheme.https,
      ),
    ),
    EnvType.local => BuildConfiguration(
      type: envType,
      networkConfiguration: const NetworkConfiguration(
        host: '', // empty
        scheme: NetworkScheme.https,
      ),
    ),
  };
}
