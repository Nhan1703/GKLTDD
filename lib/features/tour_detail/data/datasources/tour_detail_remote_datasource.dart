import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';

class TourDetailRemoteDatasource with DioErrorMapper {
  TourDetailRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> fetchPost(int id) {
    return guard(() => _dio.get<dynamic>('posts/$id'));
  }
}
