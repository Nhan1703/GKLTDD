import '../../../../core/network/http_data.dart';
import '../../../profile/domain/entities/user_entity.dart';

abstract class SearchRepository {
  Future<HttpData<List<UserEntity>>> searchUsers(String query);
}
