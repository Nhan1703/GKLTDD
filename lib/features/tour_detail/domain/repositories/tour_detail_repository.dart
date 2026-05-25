import '../../../../core/network/http_data.dart';
import '../../../explore/domain/entities/post_entity.dart';

abstract class TourDetailRepository {
  Future<HttpData<PostEntity>> fetchPostById(int id);
}
