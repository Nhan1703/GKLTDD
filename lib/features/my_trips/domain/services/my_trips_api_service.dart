import '../../../../core/network/http_data.dart';
import '../entities/album_entity.dart';
import '../repositories/my_trips_repository.dart';

/// My Trips — danh sách album (ánh xạ GET /albums).
class MyTripsApiService {
  MyTripsApiService(this._repository);

  final MyTripsRepository _repository;

  Future<HttpData<List<AlbumEntity>>> loadAlbums() => _repository.fetchAlbums();
}
