import '../../domain/entities/photo_entity.dart';

class PhotoModel {
  const PhotoModel({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  final int id;
  final int albumId;
  final String title;
  final String url;
  final String thumbnailUrl;

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: (json['id'] as num).toInt(),
      albumId: (json['albumId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
    );
  }

  PhotoEntity toEntity() =>
      PhotoEntity(id: id, albumId: albumId, title: title, url: url, thumbnailUrl: thumbnailUrl);
}
