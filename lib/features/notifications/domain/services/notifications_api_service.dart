import '../../../../core/network/http_data.dart';
import '../entities/todo_entity.dart';
import '../repositories/notifications_repository.dart';

/// Notifications — danh sách việc (ánh xạ GET /todos).
class NotificationsApiService {
  NotificationsApiService(this._repository);

  final NotificationsRepository _repository;

  Future<HttpData<List<TodoEntity>>> loadTodos() => _repository.fetchTodos();
}
