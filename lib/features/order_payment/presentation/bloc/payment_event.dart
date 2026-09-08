import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';

sealed class PaymentEvent {
  const PaymentEvent();
}

final class PaymentOrderRequested extends PaymentEvent {
  const PaymentOrderRequested(this.orderId);
  final String orderId;
}

final class PaymentAccountRequested extends PaymentEvent {
  const PaymentAccountRequested();
}

final class PaymentMethodSelected extends PaymentEvent {
  const PaymentMethodSelected(this.method);
  final PaymentMethod method;
}

final class PaymentPhoneChanged extends PaymentEvent {
  const PaymentPhoneChanged(this.phone);
  final String phone;
}

final class PaymentPhoneUnfocused extends PaymentEvent {
  const PaymentPhoneUnfocused();
}

final class PaymentSubmitted extends PaymentEvent {
  const PaymentSubmitted();
}

final class PaymentErrorDismissed extends PaymentEvent {
  const PaymentErrorDismissed();
}
