import 'package:dio/dio.dart';

/// Injects `Authorization: Bearer <token>` when [tokenProvider] returns non-empty.
class AuthBearerInterceptor extends Interceptor {
  AuthBearerInterceptor({required this.tokenProvider});

  final String? Function() tokenProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final t = tokenProvider();
    if (t != null && t.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $t';
    }
    handler.next(options);
  }
}
