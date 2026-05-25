import '../../../../core/network/http_data.dart';
import '../../../profile/domain/entities/user_entity.dart';
import '../repositories/search_repository.dart';

/// Search — lọc người dùng phía client sau GET /users.
class SearchApiService {
  SearchApiService(this._repository);

  final SearchRepository _repository;

  Future<HttpData<List<UserEntity>>> search(String q) => _repository.searchUsers(q);
}
