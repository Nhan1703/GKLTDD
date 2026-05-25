import '../../../../core/network/http_data.dart';
import '../../../explore/domain/entities/post_entity.dart';
import '../repositories/tour_detail_repository.dart';

/// Tour detail — bài đăng đơn (ánh xạ GET /posts/:id).
class TourDetailApiService {
  TourDetailApiService(this._repository);

  final TourDetailRepository _repository;

  Future<HttpData<PostEntity>> loadPost(int id) => _repository.fetchPostById(id);
}
