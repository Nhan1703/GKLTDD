import '../../../../core/network/http_data.dart';
import '../../../my_trips/domain/entities/album_entity.dart';

abstract class TripDetailRepository {
  Future<HttpData<AlbumEntity>> fetchAlbumById(int id);
}
