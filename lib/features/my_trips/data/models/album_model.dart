import '../../domain/entities/album_entity.dart';

class AlbumModel {
  const AlbumModel({required this.id, required this.userId, required this.title});

  final int id;
  final int userId;
  final String title;

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
    );
  }

  AlbumEntity toEntity() => AlbumEntity(id: id, userId: userId, title: title);
}
