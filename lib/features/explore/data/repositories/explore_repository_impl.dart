import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/http_data.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_remote_datasource.dart';
import '../models/post_model.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  ExploreRepositoryImpl(this._remote);

  final ExploreRemoteDatasource _remote;

  @override
  Future<HttpData<List<PostEntity>>> fetchPosts() async {
    final Response<dynamic> res = await _remote.fetchPosts();
    final data = res.data;
    if (data is! List<dynamic>) {
      throw const ApiParseException(message: 'Expected JSON array for /posts');
    }
    final entities = data
        .map((e) => PostModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .map((m) => m.toEntity())
        .toList(growable: false);
    return HttpData<List<PostEntity>>(
      statusCode: res.statusCode ?? 200,
      data: entities,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: _preview(data),
    );
  }

  String _preview(List<dynamic> list) {
    if (list.isEmpty) return '[]';
    return '[${list.length} items] first id: ${(list.first as Map)['id']}';
  }
}
