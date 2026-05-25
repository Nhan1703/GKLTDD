import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/http_data.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remote);

  final ProfileRemoteDatasource _remote;

  @override
  Future<HttpData<UserEntity>> fetchUserById(int id) async {
    final Response<dynamic> res = await _remote.fetchUser(id);
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw const ApiParseException(message: 'Expected JSON object for /users/:id');
    }
    final entity = UserModel.fromJson(data).toEntity();
    return HttpData<UserEntity>(
      statusCode: res.statusCode ?? 200,
      data: entity,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: entity.email,
    );
  }
}
