import 'package:order_payment/core/error/app_failure.dart';

final class PaymentFailure extends AppFailure {
  const PaymentFailure(super.message) : super(type: AppFailureType.validation);
}
