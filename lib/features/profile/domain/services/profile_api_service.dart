import '../../../../core/network/http_data.dart';
import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

/// Profile — người dùng (GET /users/:id).
class ProfileApiService {
  ProfileApiService(this._repository);

  final ProfileRepository _repository;

  Future<HttpData<UserEntity>> loadUser(int id) => _repository.fetchUserById(id);
}
