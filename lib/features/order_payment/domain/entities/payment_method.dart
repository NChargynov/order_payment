enum PaymentMethod {
  oDengi,
  mbank,
  account,
  cash;

  String get displayTitle => switch (this) {
    PaymentMethod.account => 'Внутренний кошелек',
    PaymentMethod.mbank => 'Mbank',
    PaymentMethod.oDengi => 'O!',
    PaymentMethod.cash => 'Наличными',
  };

  bool get requiresPhone => this == mbank || this == oDengi;
}
