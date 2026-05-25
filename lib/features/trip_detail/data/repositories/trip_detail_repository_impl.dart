import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/http_data.dart';
import '../../../my_trips/data/models/album_model.dart';
import '../../../my_trips/domain/entities/album_entity.dart';
import '../../domain/repositories/trip_detail_repository.dart';
import '../datasources/trip_detail_remote_datasource.dart';

class TripDetailRepositoryImpl implements TripDetailRepository {
  TripDetailRepositoryImpl(this._remote);

  final TripDetailRemoteDatasource _remote;

  @override
  Future<HttpData<AlbumEntity>> fetchAlbumById(int id) async {
    final Response<dynamic> res = await _remote.fetchAlbum(id);
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw const ApiParseException(message: 'Expected JSON object for /albums/:id');
    }
    final entity = AlbumModel.fromJson(data).toEntity();
    return HttpData<AlbumEntity>(
      statusCode: res.statusCode ?? 200,
      data: entity,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: entity.title,
    );
  }
}
