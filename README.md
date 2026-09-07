# Order payment

Архитектурный каркас Flutter-приложения оплаты заказа. Начальная страница
`OrderPaymentPage` отображает тип сборки: `local` или `dev`.

## Подготовка и запуск

```sh
flutter pub get
dart run build_runner build
```

Выберите окружение:

```sh
# Local
flutter run -t lib/main_local.dart

# Development
flutter run -t lib/main_development.dart
```

В Android Studio укажите соответствующий файл как Dart entrypoint.

## Структура

```text
lib/
├── main_local.dart
├── main_development.dart
├── app/
│   ├── application.dart
│   ├── bootstrap.dart
│   ├── di/
│   └── router/
├── core/
│   ├── config/
│   │   └── factory/
│   ├── logging/
│   └── theme/
└── features/
    └── order_payment/
        └── presentation/
            └── pages/
                └── order_payment_page.dart
```

- `app` — запуск приложения, GetIt/Injectable и навигация AutoRoute.
- `core` — конфигурация окружений, её фабрика, логирование, тема и цвета.
- `features/order_payment` — страница оплаты.

## Конфигурация и DI

Entrypoint создаёт `BuildConfiguration` через `BuildConfigurationFromEnvImpl`
и передаёт её в bootstrap. До запуска приложения конфигурация регистрируется
в GetIt через `registerSingleton`. Получение типа сборки:

```dart
getIt<BuildConfiguration>().type
```

`configuration.type.name` передаётся в `getIt.init` как environment:
`local` или `development`. `InjectableModule` регистрирует `AppRouter` и `Talker`
как lazy singletons. При сбросе контейнера вызывается `AppRouter.dispose()`.

`Application` использует `MaterialApp.router` и `TalkerRouteObserver`.
В development подключается `AppBlocObserver` для логирования событий BLoC.

DI и маршруты генерируются командой `dart run build_runner build`.
Файлы `get_it.config.dart` и `app_router.gr.dart` исключены из Git,
поэтому генерация обязательна после клонирования проекта.

## Анализ и Android-сборка

```sh
flutter analyze
flutter build apk --debug --no-pub -t lib/main_local.dart
flutter build apk --debug --no-pub -t lib/main_development.dart
```
