import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';

class ExploreRemoteDatasource with DioErrorMapper {
  ExploreRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> fetchPosts() {
    return guard(() => _dio.get<dynamic>('posts'));
  }
}
