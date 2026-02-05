import '../../domain/entities/project.dart';

class ProjectModel {
  final String title;
  final String description;
  final List<String> tags;
  final String? repoUrl;
  final String? liveUrl;
  final String? imageAsset;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.tags,
    this.repoUrl,
    this.liveUrl,
    this.imageAsset,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: _asString(json['title']),
      description: _asString(json['description']),
      tags: _asStringList(json['tags']),
      repoUrl: _asNullableString(json['repoUrl']),
      liveUrl: _asNullableString(json['liveUrl']),
      imageAsset: _asNullableString(json['imageAsset']),
    );
  }

  Project toDomain() {
    return Project(
      title: title,
      description: description,
      tags: tags,
      repoUrl: repoUrl,
      liveUrl: liveUrl,
      imageAsset: imageAsset,
    );
  }
}

String _asString(dynamic value, [String fallback = '']) =>
    value is String ? value : fallback;

String? _asNullableString(dynamic value) => value is String && value.isNotEmpty ? value : null;

List<String> _asStringList(dynamic value) {
  if (value is! List) return const [];
  return value.whereType<String>().toList(growable: false);
}
