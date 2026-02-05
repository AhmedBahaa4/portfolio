import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String title;
  final String description;
  final List<String> tags;
  final String? repoUrl;
  final String? liveUrl;
  final String? imageAsset;

  const Project({
    required this.title,
    required this.description,
    required this.tags,
    this.repoUrl,
    this.liveUrl,
    this.imageAsset,
  });

  @override
  List<Object?> get props => [title, description, tags, repoUrl, liveUrl, imageAsset];
}
