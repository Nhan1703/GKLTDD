import '../../../../core/network/http_data.dart';
import '../entities/album_entity.dart';

abstract class MyTripsRepository {
  Future<HttpData<List<AlbumEntity>>> fetchAlbums();
}
