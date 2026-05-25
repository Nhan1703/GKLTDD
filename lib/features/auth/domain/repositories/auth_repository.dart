import '../../../../core/network/http_data.dart';
import '../entities/login_result_entity.dart';

abstract class AuthRepository {
  Future<HttpData<LoginResultEntity>> login({required String email, required String password});
}
