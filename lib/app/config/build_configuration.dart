import 'package:order_payment/app/config/env_type.dart';
import 'package:order_payment/app/config/network_configuration.dart';

final class BuildConfiguration {
  const BuildConfiguration({
    required this.type,
    required this.networkConfiguration,
  });

  final EnvType type;
  final NetworkConfiguration networkConfiguration;
}
