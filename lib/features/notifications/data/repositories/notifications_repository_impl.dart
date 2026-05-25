import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/http_data.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';
import '../models/todo_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remote);

  final NotificationsRemoteDatasource _remote;

  @override
  Future<HttpData<List<TodoEntity>>> fetchTodos() async {
    final Response<dynamic> res = await _remote.fetchTodos();
    final data = res.data;
    if (data is! List<dynamic>) {
      throw const ApiParseException(message: 'Expected JSON array for /todos');
    }
    final list = data
        .map((e) => TodoModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .map((m) => m.toEntity())
        .toList(growable: false);
    return HttpData<List<TodoEntity>>(
      statusCode: res.statusCode ?? 200,
      data: list,
      reasonPhrase: res.statusMessage,
      serverMessage: res.statusMessage,
      rawBodyPreview: '[${list.length} todos]',
    );
  }
}
