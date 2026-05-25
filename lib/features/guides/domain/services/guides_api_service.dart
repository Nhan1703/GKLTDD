import '../../../../core/network/http_data.dart';
import '../entities/photo_entity.dart';
import '../repositories/guides_repository.dart';

/// Guides / gallery — ảnh (GET /photos?_limit=…).
class GuidesApiService {
  GuidesApiService(this._repository);

  final GuidesRepository _repository;

  Future<HttpData<List<PhotoEntity>>> loadPhotos({int limit = 8}) =>
      _repository.fetchPhotos(limit: limit);
}
