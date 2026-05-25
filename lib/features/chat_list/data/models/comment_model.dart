import '../../domain/entities/comment_entity.dart';

class CommentModel {
  const CommentModel({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  final int id;
  final int postId;
  final String name;
  final String email;
  final String body;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: (json['id'] as num).toInt(),
      postId: (json['postId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  CommentEntity toEntity() =>
      CommentEntity(id: id, postId: postId, name: name, email: email, body: body);
}
