import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/http_data.dart';
import '../../../explore/data/models/post_model.dart';
import '../../../explore/domain/entities/post_entity.dart';
import '../../domain/repositories/tour_detail_repository.dart';
import '../datasources/tour_detail_remote_datasource.dart';

class TourDetailRepositoryImpl implements TourDetailRepository {
  TourDetailRepositoryImpl(this._remote);

  final TourDetailRemoteDatasource _remote;

  @override
  Future<HttpData<PostEntity>> fetchPostById(int id) async {
    final Response<dynamic> res = await _remote.fetchPost(id);
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw const ApiParseException(message: 'Expected JSON object for /posts/:id');
    }
    final entity = PostModel.fromJson(data).toEntity();
    return HttpData<PostEntity>(
      statusCode: res.statusCode ?? 200,
      data: entity,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: 'post #${entity.id}',
    );
  }
}
