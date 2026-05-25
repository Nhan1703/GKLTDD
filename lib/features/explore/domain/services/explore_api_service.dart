import '../../../../core/network/http_data.dart';
import '../entities/post_entity.dart';
import '../repositories/explore_repository.dart';

/// Explore tab — danh sách “feed” (ánh xạ tới JSONPlaceholder /posts).
class ExploreApiService {
  ExploreApiService(this._repository);

  final ExploreRepository _repository;

  Future<HttpData<List<PostEntity>>> loadFeed() => _repository.fetchPosts();
}
