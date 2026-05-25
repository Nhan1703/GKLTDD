import '../../../../core/network/http_data.dart';
import '../entities/photo_entity.dart';

abstract class GuidesRepository {
  Future<HttpData<List<PhotoEntity>>> fetchPhotos({int limit = 8});
}
