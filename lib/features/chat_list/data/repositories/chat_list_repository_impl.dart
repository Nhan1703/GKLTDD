import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/http_data.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/chat_list_repository.dart';
import '../datasources/chat_list_remote_datasource.dart';
import '../models/comment_model.dart';

class ChatListRepositoryImpl implements ChatListRepository {
  ChatListRepositoryImpl(this._remote);

  final ChatListRemoteDatasource _remote;

  @override
  Future<HttpData<List<CommentEntity>>> fetchCommentsForPost({int postId = 1}) async {
    final Response<dynamic> res = await _remote.fetchComments(postId: postId);
    final data = res.data;
    if (data is! List<dynamic>) {
      throw const ApiParseException(message: 'Expected JSON array for /comments');
    }
    final list = data
        .map((e) => CommentModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .map((m) => m.toEntity())
        .toList(growable: false);
    return HttpData<List<CommentEntity>>(
      statusCode: res.statusCode ?? 200,
      data: list,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: '[${list.length} comments] postId=$postId',
    );
  }
}
