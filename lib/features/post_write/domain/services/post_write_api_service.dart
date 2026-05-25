import '../../../../core/network/http_data.dart';
import '../../../explore/domain/entities/post_entity.dart';
import '../repositories/post_write_repository.dart';

/// CRUD posts trên JSONPlaceholder (POST /posts, PUT, PATCH, DELETE).
class PostWriteApiService {
  PostWriteApiService(this._repository);

  final PostWriteRepository _repository;

  Future<HttpData<PostEntity>> create({
    required String title,
    required String body,
    required int userId,
  }) =>
      _repository.createPost(title: title, body: body, userId: userId);

  Future<HttpData<PostEntity>> replace({
    required int id,
    required String title,
    required String body,
    required int userId,
  }) =>
      _repository.replacePost(id: id, title: title, body: body, userId: userId);

  Future<HttpData<PostEntity>> patch({required int id, required Map<String, dynamic> fields}) =>
      _repository.patchPost(id: id, fields: fields);

  Future<HttpData<Map<String, dynamic>>> delete(int id) => _repository.deletePost(id);
}
