import '../../../../core/network/http_data.dart';
import '../../../my_trips/domain/entities/album_entity.dart';
import '../repositories/trip_detail_repository.dart';

/// Trip detail — album đơn (GET /albums/:id).
class TripDetailApiService {
  TripDetailApiService(this._repository);

  final TripDetailRepository _repository;

  Future<HttpData<AlbumEntity>> loadAlbum(int id) => _repository.fetchAlbumById(id);
}
