import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/http_data.dart';
import '../../domain/entities/album_entity.dart';
import '../../domain/repositories/my_trips_repository.dart';
import '../datasources/my_trips_remote_datasource.dart';
import '../models/album_model.dart';

class MyTripsRepositoryImpl implements MyTripsRepository {
  MyTripsRepositoryImpl(this._remote);

  final MyTripsRemoteDatasource _remote;

  @override
  Future<HttpData<List<AlbumEntity>>> fetchAlbums() async {
    final Response<dynamic> res = await _remote.fetchAlbums();
    final data = res.data;
    if (data is! List<dynamic>) {
      throw const ApiParseException(message: 'Expected JSON array for /albums');
    }
    final list = data
        .map((e) => AlbumModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .map((m) => m.toEntity())
        .toList(growable: false);
    return HttpData<List<AlbumEntity>>(
      statusCode: res.statusCode ?? 200,
      data: list,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: '[${list.length} albums]',
    );
  }
}
