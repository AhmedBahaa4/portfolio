import '../../domain/entities/portfolio.dart';
import 'project_model.dart';

class PortfolioModel {
  final String name;
  final String headline;
  final String location;
  final String summary;
  final List<String> skills;
  final List<ExperienceItemModel> experience;
  final List<ProjectModel> projects;
  final ContactModel contact;

  const PortfolioModel({
    required this.name,
    required this.headline,
    required this.location,
    required this.summary,
    required this.skills,
    required this.experience,
    required this.projects,
    required this.contact,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      name: _asString(json['name']),
      headline: _asString(json['headline']),
      location: _asString(json['location']),
      summary: _asString(json['summary']),
      skills: _asStringList(json['skills']),
      experience: _asMapList(json['experience'])
          .map((item) => ExperienceItemModel.fromJson(item))
          .toList(growable: false),
      projects: _asMapList(json['projects'])
          .map((item) => ProjectModel.fromJson(item))
          .toList(growable: false),
      contact: ContactModel.fromJson(_asMap(json['contact'])),
    );
  }

  Portfolio toDomain() {
    return Portfolio(
      name: name,
      headline: headline,
      location: location,
      summary: summary,
      skills: skills,
      experience: experience.map((e) => e.toDomain()).toList(growable: false),
      projects: projects.map((p) => p.toDomain()).toList(growable: false),
      contact: contact.toDomain(),
    );
  }
}

class ExperienceItemModel {
  final String company;
  final String role;
  final String period;
  final List<String> highlights;

  const ExperienceItemModel({
    required this.company,
    required this.role,
    required this.period,
    required this.highlights,
  });

  factory ExperienceItemModel.fromJson(Map<String, dynamic> json) {
    return ExperienceItemModel(
      company: _asString(json['company']),
      role: _asString(json['role']),
      period: _asString(json['period']),
      highlights: _asStringList(json['highlights']),
    );
  }

  ExperienceItem toDomain() {
    return ExperienceItem(
      company: company,
      role: role,
      period: period,
      highlights: highlights,
    );
  }
}

class ContactModel {
  final String email;
  final String? phone;
  final List<ContactLinkModel> links;

  const ContactModel({
    required this.email,
    this.phone,
    required this.links,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      email: _asString(json['email']),
      phone: _asNullableString(json['phone']),
      links: _asMapList(json['links'])
          .map((item) => ContactLinkModel.fromJson(item))
          .toList(growable: false),
    );
  }

  Contact toDomain() {
    return Contact(
      email: email,
      phone: phone,
      links: links.map((l) => l.toDomain()).toList(growable: false),
    );
  }
}

class ContactLinkModel {
  final String label;
  final String url;

  const ContactLinkModel({required this.label, required this.url});

  factory ContactLinkModel.fromJson(Map<String, dynamic> json) {
    return ContactLinkModel(
      label: _asString(json['label']),
      url: _asString(json['url']),
    );
  }

  ContactLink toDomain() => ContactLink(label: label, url: url);
}

String _asString(dynamic value, [String fallback = '']) =>
    value is String ? value : fallback;

String? _asNullableString(dynamic value) =>
    value is String && value.isNotEmpty ? value : null;

Map<String, dynamic> _asMap(dynamic value) =>
    value is Map<String, dynamic> ? value : const <String, dynamic>{};

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return const [];
  final maps = <Map<String, dynamic>>[];
  for (final item in value) {
    if (item is Map<String, dynamic>) maps.add(item);
  }
  return maps;
}

List<String> _asStringList(dynamic value) {
  if (value is! List) return const [];
  return value.whereType<String>().toList(growable: false);
}
