import '../../../../core/network/http_data.dart';
import '../entities/comment_entity.dart';

abstract class ChatListRepository {
  Future<HttpData<List<CommentEntity>>> fetchCommentsForPost({int postId = 1});
}
