import 'package:dio/dio.dart';

/// Application-level API failure (mapped from [DioException] and status codes).
sealed class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.cause,
  });

  final String message;
  final int? statusCode;
  final Object? cause;

  static ApiException fromDio(DioException e) {
    if (_isOffline(e)) {
      return NetworkException(
        message: _offlineMessage(e),
        cause: e,
      );
    }
    final code = e.response?.statusCode;
    final serverMsg = _extractServerMessage(e.response?.data);
    switch (code) {
      case 401:
        return UnauthorizedException(message: serverMsg ?? 'Unauthorized', statusCode: code, cause: e);
      case 403:
        return ForbiddenException(message: serverMsg ?? 'Forbidden', statusCode: code, cause: e);
      case 404:
        return NotFoundException(message: serverMsg ?? 'Not found', statusCode: code, cause: e);
      case 422:
        return ValidationException(message: serverMsg ?? 'Validation failed', statusCode: code, cause: e);
      default:
        if (code != null && code >= 500) {
          return ServerException(
            message: serverMsg ?? 'Server error',
            statusCode: code,
            cause: e,
          );
        }
        return UnknownApiException(
          message: serverMsg ?? e.message ?? 'Request failed',
          statusCode: code,
          cause: e,
        );
    }
  }

  static bool _isOffline(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.error.toString().contains('SocketException');
  }

  static String _offlineMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Timeout — kiểm tra mạng hoặc tăng timeout trong ApiConfig.';
      default:
        return 'Không có kết nối mạng hoặc máy chủ không phản hồi.';
    }
  }

  static String? _extractServerMessage(dynamic data) {
    if (data is Map) {
      final err = data['error'];
      if (err is String) return err;
      final msg = data['message'];
      if (msg is String) return msg;
    }
    if (data is String && data.isNotEmpty) return data;
    return null;
  }
}

class NetworkException extends ApiException {
  const NetworkException({required super.message, super.cause}) : super(statusCode: null);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({required super.message, super.statusCode, super.cause});
}

class ForbiddenException extends ApiException {
  const ForbiddenException({required super.message, super.statusCode, super.cause});
}

class NotFoundException extends ApiException {
  const NotFoundException({required super.message, super.statusCode, super.cause});
}

class ValidationException extends ApiException {
  const ValidationException({required super.message, super.statusCode, super.cause});
}

class ServerException extends ApiException {
  const ServerException({required super.message, super.statusCode, super.cause});
}

class UnknownApiException extends ApiException {
  const UnknownApiException({required super.message, super.statusCode, super.cause});
}

class ApiParseException extends ApiException {
  const ApiParseException({required super.message, super.cause}) : super(statusCode: null);
}
