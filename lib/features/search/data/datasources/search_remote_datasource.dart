import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';

class SearchRemoteDatasource with DioErrorMapper {
  SearchRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> fetchAllUsers() => guard(() => _dio.get<dynamic>('users'));
}
