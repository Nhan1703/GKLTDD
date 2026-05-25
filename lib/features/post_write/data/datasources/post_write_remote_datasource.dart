import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';

class PostWriteRemoteDatasource with DioErrorMapper {
  PostWriteRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> create(Map<String, dynamic> body) =>
      guard(() => _dio.post<dynamic>('posts', data: body));

  Future<Response<dynamic>> replace(int id, Map<String, dynamic> body) =>
      guard(() => _dio.put<dynamic>('posts/$id', data: body));

  Future<Response<dynamic>> patch(int id, Map<String, dynamic> body) =>
      guard(() => _dio.patch<dynamic>('posts/$id', data: body));

  Future<Response<dynamic>> delete(int id) => guard(() => _dio.delete<dynamic>('posts/$id'));
}
