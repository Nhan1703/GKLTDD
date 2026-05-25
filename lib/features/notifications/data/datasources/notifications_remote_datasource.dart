import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';

class NotificationsRemoteDatasource with DioErrorMapper {
  NotificationsRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> fetchTodos() => guard(() => _dio.get<dynamic>('todos'));
}
