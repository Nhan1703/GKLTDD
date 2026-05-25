import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/http_data.dart';
import '../../domain/entities/login_result_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDatasource _remote;

  @override
  Future<HttpData<LoginResultEntity>> login({required String email, required String password}) async {
    final Response<dynamic> res = await _remote.login(email: email, password: password);
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw const ApiParseException(message: 'Expected JSON object for /login');
    }
    final entity = LoginResponseModel.fromJson(data).toEntity();
    return HttpData<LoginResultEntity>(
      statusCode: res.statusCode ?? 200,
      data: entity,
      reasonPhrase: res.statusMessage,
      serverMessage: data['error'] as String? ?? res.statusMessage,
      rawBodyPreview: 'token length=${entity.token.length}',
    );
  }
}
