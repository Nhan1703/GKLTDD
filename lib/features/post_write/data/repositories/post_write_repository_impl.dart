import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/http_data.dart';
import '../../../explore/data/models/post_model.dart';
import '../../../explore/domain/entities/post_entity.dart';
import '../../domain/repositories/post_write_repository.dart';
import '../datasources/post_write_remote_datasource.dart';

class PostWriteRepositoryImpl implements PostWriteRepository {
  PostWriteRepositoryImpl(this._remote);

  final PostWriteRemoteDatasource _remote;

  PostEntity _parsePost(Response<dynamic> res) {
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw const ApiParseException(message: 'Expected JSON object for post response');
    }
    return PostModel.fromJson(data).toEntity();
  }

  @override
  Future<HttpData<PostEntity>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    final res = await _remote.create(<String, dynamic>{'title': title, 'body': body, 'userId': userId});
    final entity = _parsePost(res);
    return HttpData<PostEntity>(
      statusCode: res.statusCode ?? 201,
      data: entity,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: 'created id=${entity.id}',
    );
  }

  @override
  Future<HttpData<PostEntity>> replacePost({
    required int id,
    required String title,
    required String body,
    required int userId,
  }) async {
    final res = await _remote.replace(
      id,
      <String, dynamic>{'id': id, 'title': title, 'body': body, 'userId': userId},
    );
    final entity = _parsePost(res);
    return HttpData<PostEntity>(
      statusCode: res.statusCode ?? 200,
      data: entity,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: 'replaced #$id',
    );
  }

  @override
  Future<HttpData<PostEntity>> patchPost({required int id, required Map<String, dynamic> fields}) async {
    final res = await _remote.patch(id, fields);
    final entity = _parsePost(res);
    return HttpData<PostEntity>(
      statusCode: res.statusCode ?? 200,
      data: entity,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: 'patched #$id',
    );
  }

  @override
  Future<HttpData<Map<String, dynamic>>> deletePost(int id) async {
    final res = await _remote.delete(id);
    final body = res.data;
    final map = body is Map<String, dynamic> ? body : <String, dynamic>{};
    return HttpData<Map<String, dynamic>>(
      statusCode: res.statusCode ?? 200,
      data: map,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: 'deleted #$id',
    );
  }
}
