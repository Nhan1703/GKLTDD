import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';

class ProfileRemoteDatasource with DioErrorMapper {
  ProfileRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> fetchUser(int id) => guard(() => _dio.get<dynamic>('users/$id'));
}
