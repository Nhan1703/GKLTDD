import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';

class MyTripsRemoteDatasource with DioErrorMapper {
  MyTripsRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> fetchAlbums() => guard(() => _dio.get<dynamic>('albums'));
}
