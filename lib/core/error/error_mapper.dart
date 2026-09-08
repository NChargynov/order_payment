import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../network/api_exception.dart';
import 'app_failure.dart';

AppFailure mapException(Object error) {
  if (error is AppFailure) return error;

  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppFailure(
          'Превышено время ожидания ответа сервера',
          type: AppFailureType.network,
        );
      case DioExceptionType.transformTimeout:
        return const AppFailure(
          'Превышено время обработки ответа сервера',
          type: AppFailureType.invalidData,
        );
      case DioExceptionType.connectionError:
        return const AppFailure(
          'Не удалось подключиться к серверу. Проверьте интернет-соединение',
          type: AppFailureType.network,
        );
      case DioExceptionType.badCertificate:
        return const AppFailure(
          'Не удалось установить защищённое соединение с сервером',
          type: AppFailureType.network,
        );
      case DioExceptionType.cancel:
        return const AppFailure(
          'Запрос отменён',
          type: AppFailureType.cancelled,
        );
      case DioExceptionType.badResponse:
        return AppFailure(
          _serverMessage(error.response?.data) ?? 'Ошибка сервера',
          type: AppFailureType.server,
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.unknown:
        if (error.error != null) return mapException(error.error!);
    }
  }

  if (error is ApiException) {
    return AppFailure(
      error.message.trim().isEmpty ? 'Ошибка сервера' : error.message.trim(),
      type: AppFailureType.server,
    );
  }
  if (error is TimeoutException) {
    return const AppFailure(
      'Превышено время ожидания ответа сервера',
      type: AppFailureType.network,
    );
  }
  if (error is SocketException || error is HandshakeException) {
    return const AppFailure(
      'Не удалось подключиться к серверу. Проверьте интернет-соединение',
      type: AppFailureType.network,
    );
  }
  if (error is FormatException || error is TypeError) {
    return const AppFailure(
      'Получены некорректные данные сервера',
      type: AppFailureType.invalidData,
    );
  }
  return const AppFailure('Не удалось выполнить операцию');
}

String? _serverMessage(Object? data) {
  if (data is! Map) return null;
  final message = data['message'];
  if (message is! String || message.trim().isEmpty) return null;
  return message.trim();
}
