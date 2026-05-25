import '../../../../core/network/http_data.dart';
import '../entities/todo_entity.dart';

abstract class NotificationsRepository {
  Future<HttpData<List<TodoEntity>>> fetchTodos();
}
