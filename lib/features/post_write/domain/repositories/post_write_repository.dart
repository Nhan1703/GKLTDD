import '../../../../core/network/http_data.dart';
import '../../../explore/domain/entities/post_entity.dart';

abstract class PostWriteRepository {
  Future<HttpData<PostEntity>> createPost({
    required String title,
    required String body,
    required int userId,
  });

  Future<HttpData<PostEntity>> replacePost({
    required int id,
    required String title,
    required String body,
    required int userId,
  });

  Future<HttpData<PostEntity>> patchPost({
    required int id,
    required Map<String, dynamic> fields,
  });

  Future<HttpData<Map<String, dynamic>>> deletePost(int id);
}
