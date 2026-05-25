import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/http_data.dart';
import '../../domain/entities/photo_entity.dart';
import '../../domain/repositories/guides_repository.dart';
import '../datasources/guides_remote_datasource.dart';
import '../models/photo_model.dart';

class GuidesRepositoryImpl implements GuidesRepository {
  GuidesRepositoryImpl(this._remote);

  final GuidesRemoteDatasource _remote;

  @override
  Future<HttpData<List<PhotoEntity>>> fetchPhotos({int limit = 8}) async {
    final Response<dynamic> res = await _remote.fetchPhotos(limit: limit);
    final data = res.data;
    if (data is! List<dynamic>) {
      throw const ApiParseException(message: 'Expected JSON array for /photos');
    }
    final list = data
        .map((e) => PhotoModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .map((m) => m.toEntity())
        .toList(growable: false);
    return HttpData<List<PhotoEntity>>(
      statusCode: res.statusCode ?? 200,
      data: list,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: '[${list.length} photos]',
    );
  }
}
