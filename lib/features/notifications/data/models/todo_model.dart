import '../../domain/entities/todo_entity.dart';

class TodoModel {
  const TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  final int id;
  final int userId;
  final String title;
  final bool completed;

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }

  TodoEntity toEntity() => TodoEntity(id: id, userId: userId, title: title, completed: completed);
}
