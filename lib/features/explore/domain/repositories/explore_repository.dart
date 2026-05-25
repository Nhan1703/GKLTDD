import '../../../../core/network/http_data.dart';
import '../entities/post_entity.dart';

abstract class ExploreRepository {
  Future<HttpData<List<PostEntity>>> fetchPosts();
}
