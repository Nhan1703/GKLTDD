import 'package:dio/dio.dart';

import 'api_config.dart';
import 'interceptors/auth_bearer_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Thin wrapper around [Dio] with project defaults.
class ApiClient {
  ApiClient(ApiConfig config) : _config = config {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${config.baseUrl}/',
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.sendTimeout,
        responseType: ResponseType.json,
        headers: <String, dynamic>{
          Headers.acceptHeader: 'application/json',
          Headers.contentTypeHeader: Headers.jsonContentType,
        },
      ),
    );

    final tp = config.tokenProvider;
    if (tp != null) {
      _dio.interceptors.add(AuthBearerInterceptor(tokenProvider: tp));
    }
    if (config.enableLogging) {
      _dio.interceptors.add(buildLoggingInterceptor());
    }
  }

  final ApiConfig _config;
  late final Dio _dio;

  Dio get dio => _dio;

  ApiConfig get config => _config;
}
