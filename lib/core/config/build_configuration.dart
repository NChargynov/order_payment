import 'package:order_payment/core/config/env_type.dart';
import 'package:order_payment/core/config/network_configuration.dart';

final class BuildConfiguration {
  const BuildConfiguration({
    required this.type,
    required this.networkConfiguration,
  });

  final EnvType type;
  final NetworkConfiguration networkConfiguration;
}
