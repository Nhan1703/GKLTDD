import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Wraps Dio calls and maps [DioException] → [ApiException].
mixin DioErrorMapper {
  Future<T> guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
