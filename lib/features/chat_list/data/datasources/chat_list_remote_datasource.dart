import 'package:dio/dio.dart';

import '../../../../core/network/dio_error_mapper.dart';

class ChatListRemoteDatasource with DioErrorMapper {
  ChatListRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> fetchComments({required int postId}) {
    return guard(() => _dio.get<dynamic>(
          'comments',
          queryParameters: <String, dynamic>{'postId': postId},
        ));
  }
}
