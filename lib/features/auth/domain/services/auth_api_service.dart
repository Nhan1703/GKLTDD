import '../../../../core/network/http_data.dart';
import '../entities/login_result_entity.dart';
import '../repositories/auth_repository.dart';

/// Sign-in — ReqRes POST /login (token thật từ server demo).
class AuthApiService {
  AuthApiService(this._repository);

  final AuthRepository _repository;

  Future<HttpData<LoginResultEntity>> signIn({required String email, required String password}) =>
      _repository.login(email: email, password: password);
}
