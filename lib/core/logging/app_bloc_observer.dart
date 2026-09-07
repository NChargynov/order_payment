import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('BLoC onError: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log('BLoC onTransition: $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onClose(BlocBase bloc) {
    log('BLoC closed: ${bloc.runtimeType}');
    super.onClose(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log('BLoC event: ${bloc.runtimeType} $event');
    super.onEvent(bloc, event);
  }

  @override
  void onCreate(BlocBase bloc) {
    log('BLoC created: ${bloc.runtimeType}');
    super.onCreate(bloc);
  }
}
