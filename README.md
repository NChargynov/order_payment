# order_payment

Flutter-проект экрана оплаты заказа. Текущая структура: отдельные entrypoints,
конфигурация окружения, GetIt/Injectable, AutoRoute, Talker и placeholder страницы
оплаты. API, mock-источники и бизнес-логика пока не реализованы.

## Запуск

```sh
flutter pub get
dart run build_runner build
flutter run -t lib/main_local.dart
flutter run -t lib/main_development.dart
```

В Android Studio нужно выбрать один из этих файлов как Dart entrypoint.
`lib/app/bootstrap.dart` содержит общий bootstrap `startApplication`, а не функцию `main`;
обычный запуск без `-t` не подходит.

## Текущая архитектура

```text
lib/
├── main_local.dart
├── main_development.dart
├── app/
│   ├── application.dart
│   ├── bootstrap.dart
│   ├── di/
│   │   ├── get_it.dart
│   │   ├── get_it.config.dart       # generated
│   │   └── injectable_module.dart
│   └── router/
│       ├── app_router.dart
│       └── app_router.gr.dart      # generated
├── core/
│   ├── config/
│   │   ├── build_configuration.dart
│   │   ├── env_type.dart
│   │   ├── network_configuration.dart
│   │   ├── network_scheme.dart
│   │   └── factory/
│   │       ├── build_configuration_from_env.dart
│   │       └── build_configuration_from_env_impl.dart
│   ├── logging/
│   │   └── app_bloc_observer.dart
│   └── theme/
│       ├── app_colors.dart
│       └── theme.dart
└── features/
    └── order_payment/
        └── presentation/
            └── pages/
                └── order_payment_page.dart
test/
└── app/
    └── bootstrap_test.dart
```

- `app` собирает приложение: bootstrap, корневой виджет, DI и маршруты.
  DI расположен здесь, поскольку регистрирует роутер и связывает части приложения.
- `core` содержит общие конфигурацию, логирование и тему; не импортирует `app`
  или конкретные features. Конфигурационные типы не являются domain entities,
  поэтому расположены непосредственно в `core/config` вместе с папкой их фабрики.
- `features` группирует код по пользовательскому сценарию. Страница относится
  к `order_payment/presentation/pages`. `data` и `domain` будут добавлены вместе
  с их реализацией; пустые файлы ради дерева не создаются.
- `test/app` зеркалит слой приложения и проверяет его bootstrap.

- Актуальный конфиг называется `BuildConfiguration`, класса `AppConfig` нет.
  `BuildConfigurationFromEnvImpl` создаёт его по `EnvType.local` или
  `EnvType.development`; вложенный `NetworkConfiguration` формирует URL.
- Entrypoint передаёт конфиг в `startApplication`, где он определяет включение
  `AppBlocObserver` в development и окружение Injectable через
  `configureDependencies(environment: buildConfiguration.type)`.
  Сам объект конфигурации пока не зарегистрирован в DI.
- `InjectableModule` регистрирует `AppRouter` и `Talker` как lazy singletons.
  При сбросе GetIt роутер освобождается через `dispose`.
- Bootstrap ожидает инициализацию DI перед `runApp`. Инициализация выполняется
  один раз; в тестах перед следующим запуском нужен `await getIt.reset()`.
- `Application` использует `MaterialApp.router` и `TalkerRouteObserver`;
  начальный маршрут - `OrderPaymentPage`.

Прежние `DATA_SOURCE` / `BASE_URL` через `dart-define` в текущем коде не читаются.
Выбор реализации data source будет связан с окружением Injectable: `local` -
локальная реализация, `development` - remote. Передача окружения уже настроена;
сами источники ещё не реализованы. В local host пока пустой: получающийся
`https:///api/` непригоден для запросов и не должен использоваться local-источником.

## Регистрация будущих источников данных

`BuildConfiguration.type` - единственная точка выбора окружения. DI получает
обязательный `EnvType` и передаёт его `.name` в сгенерированный `getIt.init`.
`Future.sync` ожидает как текущий синхронный init, так и будущий асинхронный init
при добавлении `@preResolve`. Окружение выбирается при старте приложения;
повторный init того же контейнера для переключения окружения не предусмотрен.

Планируемые файлы внутри feature `order_payment`:

- `domain/repositories/order_payment_repository.dart` - контракт repository;
- `data/repositories/order_payment_repository_impl.dart` - единая реализация;
- `data/datasources/order_payment_data_source.dart` - общий контракт источника;
- `data/datasources/remote/remote_data_source_impl.dart` - remote;
- `data/datasources/local/local_data_source_impl.dart` - local.

Пример будущих регистраций (эти классы пока не созданы):

```dart
@LazySingleton(as: OrderPaymentDataSource, env: ['development'])
class RemoteDataSourceImpl implements OrderPaymentDataSource {
  // Реализация HTTP-контракта на следующем этапе.
}

@LazySingleton(as: OrderPaymentDataSource, env: ['local'])
class LocalDataSourceImpl implements OrderPaymentDataSource {
  // Локальные данные того же контракта на следующем этапе.
}

@LazySingleton(as: OrderPaymentRepository)
class OrderPaymentRepositoryImpl implements OrderPaymentRepository {
  OrderPaymentRepositoryImpl(this.dataSource);

  final OrderPaymentDataSource dataSource;
  // Реализация методов repository на следующем этапе.
}
```

Repository не имеет фильтра `env` и зависит от абстрактного data source.
Injectable зарегистрирует под этим типом только реализацию выбранного окружения.
`AppRouter` и `Talker` также остаются общими для обоих окружений.
Domain-контракты не зависят от DI. Проверок окружения внутри repository, BLoC
или UI не требуется.

Имена окружений должны совпадать с `EnvType.name`: `development` и `local`.
Стандартная аннотация Injectable `@dev` означает `dev` и здесь не подходит.
После добавления реализаций нужно повторить генерацию и проверить выбор каждой
реализации тестами; текущий тест проверяет передачу окружения и общие зависимости.

## Проверка

```sh
flutter analyze
flutter test
flutter build apk --debug --no-pub -t lib/main_local.dart
flutter build apk --debug --no-pub -t lib/main_development.dart
```

Тест проверяет запуск обоих entrypoints, окружение DI, начальный маршрут
и BLoC observer.
После изменения DI-аннотаций или маршрутов нужно повторить code generation;
`get_it.config.dart` и `app_router.gr.dart` не редактируются вручную.
Сгенерированные файлы исключены через `.gitignore`, поэтому после клонирования
генерация обязательна до анализа, тестов и запуска.
