import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/http_data.dart';
import '../../../profile/data/models/user_model.dart';
import '../../../profile/domain/entities/user_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._remote);

  final SearchRemoteDatasource _remote;

  @override
  Future<HttpData<List<UserEntity>>> searchUsers(String query) async {
    final Response<dynamic> res = await _remote.fetchAllUsers();
    final data = res.data;
    if (data is! List<dynamic>) {
      throw const ApiParseException(message: 'Expected JSON array for /users');
    }
    final all = data
        .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e as Map)).toEntity())
        .toList(growable: false);
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? all
        : all
            .where(
              (u) =>
                  u.name.toLowerCase().contains(q) ||
                  u.email.toLowerCase().contains(q) ||
                  u.username.toLowerCase().contains(q),
            )
            .toList(growable: false);
    return HttpData<List<UserEntity>>(
      statusCode: res.statusCode ?? 200,
      data: filtered,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: 'matched ${filtered.length} / ${all.length}',
    );
  }
}
