import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:order_payment/core/contracts/dependency.dart';
import 'package:order_payment/core/types/json_map.dart';

abstract class NetworkService implements Service {
  NetworkService({required this.client});

  @protected
  final Dio client;

  Future<Response<T>> get<T>(
    String path, {
    JsonMap? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return client.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return client.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
