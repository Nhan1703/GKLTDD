import 'token_store.dart';

/// Global HTTP settings. Override base URLs via `--dart-define` in CI / flavors.
class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 25),
    this.receiveTimeout = const Duration(seconds: 25),
    this.sendTimeout = const Duration(seconds: 25),
    this.tokenProvider,
    this.enableLogging = true,
  });

  /// JSONPlaceholder — CRUD + lists (public, no key).
  static ApiConfig jsonPlaceholder({
    String? Function()? tokenProvider,
    bool enableLogging = true,
  }) {
    const fromEnv = String.fromEnvironment('JP_BASE_URL', defaultValue: '');
    final base = fromEnv.isNotEmpty
        ? fromEnv
        : const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'https://jsonplaceholder.typicode.com',
          );
    return ApiConfig(
      baseUrl: base.endsWith('/') ? base.substring(0, base.length - 1) : base,
      tokenProvider: tokenProvider ?? () => TokenStore.instance.accessToken,
      enableLogging: enableLogging,
    );
  }

  /// ReqRes — login / user samples.
  static ApiConfig reqRes({bool enableLogging = true}) {
    const fromEnv = String.fromEnvironment('REQRES_BASE_URL', defaultValue: '');
    final base = fromEnv.isNotEmpty
        ? fromEnv
        : 'https://reqres.in/api';
    return ApiConfig(
      baseUrl: base.endsWith('/') ? base.substring(0, base.length - 1) : base,
      tokenProvider: null,
      enableLogging: enableLogging,
    );
  }

  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final String? Function()? tokenProvider;
  final bool enableLogging;
}
