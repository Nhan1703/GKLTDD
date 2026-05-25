import '../../../../core/network/http_data.dart';
import '../entities/user_entity.dart';

abstract class ProfileRepository {
  Future<HttpData<UserEntity>> fetchUserById(int id);
}
