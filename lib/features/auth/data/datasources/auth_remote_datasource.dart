import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';

class AuthRemoteDatasource with DioErrorMapper {
  AuthRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> login({required String email, required String password}) {
    return guard(
      () => _dio.post<dynamic>(
        'login',
        data: <String, dynamic>{'email': email, 'password': password},
      ),
    );
  }
}
