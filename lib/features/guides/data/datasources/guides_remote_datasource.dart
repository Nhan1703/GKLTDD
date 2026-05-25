import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';

class GuidesRemoteDatasource with DioErrorMapper {
  GuidesRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> fetchPhotos({required int limit}) {
    return guard(
      () => _dio.get<dynamic>(
        'photos',
        queryParameters: <String, dynamic>{'_limit': limit},
      ),
    );
  }
}
