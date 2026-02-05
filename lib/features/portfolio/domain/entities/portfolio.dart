import 'package:equatable/equatable.dart';

import 'project.dart';

class Portfolio extends Equatable {
  final String name;
  final String headline;
  final String location;
  final String summary;
  final String? cvUrl;
  final List<String> skills;
  final List<ExperienceItem> experience;
  final List<Project> projects;
  final Contact contact;

  const Portfolio({
    required this.name,
    required this.headline,
    required this.location,
    required this.summary,
    this.cvUrl,
    required this.skills,
    required this.experience,
    required this.projects,
    required this.contact,
  });

  @override
  List<Object?> get props => [
        name,
        headline,
        location,
        summary,
        cvUrl,
        skills,
        experience,
        projects,
        contact,
      ];
}

class ExperienceItem extends Equatable {
  final String company;
  final String role;
  final String period;
  final List<String> highlights;

  const ExperienceItem({
    required this.company,
    required this.role,
    required this.period,
    required this.highlights,
  });

  @override
  List<Object?> get props => [company, role, period, highlights];
}

class Contact extends Equatable {
  final String email;
  final String? phone;
  final List<ContactLink> links;

  const Contact({
    required this.email,
    this.phone,
    required this.links,
  });

  @override
  List<Object?> get props => [email, phone, links];
}

class ContactLink extends Equatable {
  final String label;
  final String url;

  const ContactLink({required this.label, required this.url});

  @override
  List<Object?> get props => [label, url];
}
