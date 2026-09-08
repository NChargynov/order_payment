import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payment/app/application.dart';
import 'package:order_payment/app/config/build_configuration.dart';
import 'package:order_payment/app/di/get_it.dart';
import 'package:order_payment/app/logging/app_bloc_observer.dart';

Future<void> startApplication(BuildConfiguration buildConfiguration) async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(configuration: buildConfiguration);
  if (buildConfiguration.type.isDevelopment) {
    Bloc.observer = AppBlocObserver();
  }
  runApp(Application());
}
