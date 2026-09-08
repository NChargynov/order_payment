import 'package:order_payment/app/config/network_scheme.dart';

final class NetworkConfiguration {
  const NetworkConfiguration({
    required this.host,
    this.scheme = NetworkScheme.https,
    this.port,
  });

  final NetworkScheme scheme;
  final String host;
  final int? port;

  String get _portStr => port == null ? '' : ':$port';

  String get url => '${scheme.name}://$host$_portStr/';
}
