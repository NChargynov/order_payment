import 'package:injectable/injectable.dart';
import 'package:order_payment/core/network/internal_api.dart';

@Injectable(as: InternalApi)
class InternalApiImpl extends InternalApi {
  InternalApiImpl({required super.client});
}
