import 'package:dio/dio.dart';

import '../core/network/token_store.dart';
import '../core/session/user_session.dart';

/// API Fellow4U — MySQL backend (Node.js).
/// Chạy backend: `cd backend && npm install && npm start`
/// Flutter: `flutter run --dart-define=FELLOW4U_BASE_URL=http://127.0.0.1:3000/api`
abstract final class Fellow4uSqlApi {
  static const String _baseUrl = String.fromEnvironment(
    'FELLOW4U_BASE_URL',
    defaultValue: 'http://127.0.0.1:3000/api',
  );

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ),
  );

  static void _setToken(String? token) {
    if (token == null || token.isEmpty) {
      _dio.options.headers.remove('Authorization');
      TokenStore.instance.setAccessToken(null);
      UserSession.instance.clear();
      return;
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
    TokenStore.instance.setAccessToken(token);
  }

  static String _messageFromDio(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] != null) return '${data['error']}';
    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Máy chủ phản hồi chậm (Render đang khởi động hoặc database chưa kết nối). '
          'Thử lại sau 30 giây, hoặc mở $_baseUrl/health trước khi đăng ký.';
    }
    return e.message ?? 'Network error';
  }

  // --- Auth ---
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final data = res.data ?? {};
      final token = data['token'] as String?;
      if (token != null) _setToken(token);
      UserSession.instance.setFromAuthResponse(data);
      return data;
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? username,
    String? firstName,
    String? lastName,
    String? country,
    String role = 'traveler',
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
          'country': country,
          'role': role,
        },
      );
      final data = res.data ?? {};
      final token = data['token'] as String?;
      if (token != null) _setToken(token);
      UserSession.instance.setFromAuthResponse(data);
      return data;
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post('/auth/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  // --- Profile ---
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/profile');
      final data = res.data ?? {};
      final raw = data['user'];
      if (raw is Map) {
        UserSession.instance.setUser(Map<String, dynamic>.from(raw));
      }
      return data;
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>('/profile', data: body);
      final data = res.data ?? {};
      final raw = data['user'];
      if (raw is Map) {
        UserSession.instance.setUser(Map<String, dynamic>.from(raw));
      }
      return data;
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  // --- Tours & search ---
  static Future<List<Map<String, dynamic>>> getTours() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/tours');
      final list = res.data?['tours'];
      if (list is List) {
        return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static Future<Map<String, dynamic>> getTour(int id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/tours/$id');
      return Map<String, dynamic>.from(res.data?['tour'] as Map? ?? {});
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static Future<List<Map<String, dynamic>>> search(String q) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/search', queryParameters: {'q': q});
      final list = res.data?['tours'];
      if (list is List) {
        return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  // --- Trips, photos, notifications, payments ---
  static Future<List<Map<String, dynamic>>> getTrips() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/trips');
      final list = res.data?['trips'];
      if (list is List) {
        return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static Future<Map<String, dynamic>> getTrip(int id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/trips/$id');
      return Map<String, dynamic>.from(res.data?['trip'] as Map? ?? {});
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static Future<void> addTrip(Map<String, dynamic> body) async {
    try {
      await _dio.post('/trips', data: body);
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static Future<List<Map<String, dynamic>>> getPhotos() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/photos');
      final list = res.data?['photos'];
      if (list is List) {
        return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static Future<void> addPhoto({required String imageUrl, String? caption}) async {
    try {
      await _dio.post('/photos', data: {'imageUrl': imageUrl, 'caption': caption});
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/notifications');
      final list = res.data?['notifications'];
      if (list is List) {
        return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static Future<void> submitPayment(Map<String, dynamic> body) async {
    try {
      await _dio.post('/payments', data: body);
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  static void signOut() {
    _setToken(null);
  }

  static Future<void> submitTripInformation(Map<String, dynamic> body) async {
    try {
      await _dio.post('/trip-information', data: body);
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }
}
