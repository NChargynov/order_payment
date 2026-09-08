# Order payment

Экран оплаты заказа на Flutter: выбор метода оплаты, проверка телефона и баланса,
состав заказа, итоговая сумма и результат оплаты. Есть mock и remote источники данных.

## Требования

- Flutter 3.47.2 stable (Dart 3.13.2).
- Android SDK или Xcode для iOS, эмулятор либо подключённое устройство.

## Запуск

```sh
git clone https://github.com/NChargynov/order_payment.git
cd order_payment
flutter pub get
dart run build_runner build
```

Генерация после клонирования обязательна: файлы DI, маршрутов и ссылок на ассеты
исключены из Git.

В VS Code установите расширение Flutter. В разделе **Run and Debug** выберите
`Order payment (local)` или `Order payment (development)`, выберите устройство
и нажмите **F5**. Конфигурации находятся в `.vscode/launch.json`.

### Mock

```sh
flutter run -t lib/main_local.dart
```

Backend не нужен. `LocalDataSourceImpl` возвращает заказ на 570 сом, четыре метода
оплаты и аккаунт с балансом 3000 сом. Оплата имитируется успешно с задержкой 500 мс.

### Remote API

В `lib/app/config/factory/build_configuration_from_env_impl.dart` замените
`_developmentBaseUrl` полным адресом своего backend со схемой и завершающим `/`.
Например:

```dart
static const _developmentBaseUrl = 'https://api.example.com/api/';
```

Адрес в примере нужно заменить. Backend должен поддерживать API-контракты из ТЗ;
пути `order/details/...`, `user/account` и `order-payment/...` добавляются к `baseUrl`.

```sh
flutter run -t lib/main_development.dart
```

## Переключение источника данных

Источник выбирается через `EnvType` в entrypoint: `local` — mock,
`development` — remote. Для переключения достаточно выбрать соответствующий
файл в команде запуска или настройках IDE.

`configureDependencies` в `lib/app/di/get_it.dart` передаёт окружение в Injectable.
Он регистрирует нужную реализацию `PaymentDataSource`; UI, BLoC и use cases
остаются общими. Flavors, `.env` и `--dart-define` не используются.

## Архитектура

Feature-first / Clean Architecture. Оплата находится в `lib/features/order_payment`:

- `data` — local/remote datasources, модели, DTO и реализация repository;
- `domain` — entities, контракт repository, use cases, расчёты и валидация;
- `presentation` — PaymentBloc, состояния, события, страница и виджеты.

DI настроен через GetIt/Injectable в `lib/app/di`, конфигурация — в `lib/app/config`.
Общие виджеты, тема, сетевой слой и обработчик ошибок находятся в `lib/core`.

## Примечания

- `orderId` по умолчанию — `'1'`, задаётся в `OrderPaymentPage`.
- Для MBANK и O_DENGI нужен номер из 12 цифр, начинающийся с `996`, например `996700123456`.
- Remote-оплата считается успешной при HTTP 200.
- В `test/features/order_payment` есть тесты расчёта суммы и BLoC.

```sh
flutter analyze
flutter test
```

## Repository

[GitHub — NChargynov/order_payment](https://github.com/NChargynov/order_payment)

![img.png](img.png)

![img_1.png](img_1.png)
