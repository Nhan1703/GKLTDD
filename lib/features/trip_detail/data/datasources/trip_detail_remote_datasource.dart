import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';

class TripDetailRemoteDatasource with DioErrorMapper {
  TripDetailRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> fetchAlbum(int id) => guard(() => _dio.get<dynamic>('albums/$id'));
}
