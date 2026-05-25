import '../../../../core/network/http_data.dart';
import '../entities/comment_entity.dart';
import '../repositories/chat_list_repository.dart';

/// Chat list — luồng bình luận theo bài (GET /comments?postId=…).
class ChatListApiService {
  ChatListApiService(this._repository);

  final ChatListRepository _repository;

  Future<HttpData<List<CommentEntity>>> loadThread({int postId = 1}) =>
      _repository.fetchCommentsForPost(postId: postId);
}
