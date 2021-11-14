import 'package:equatable/equatable.dart';

class Crew extends Equatable {
  Crew({
    required this.job,
    required this.character,
    required this.name,
    required this.id,
    required this.profilePath,
  });

  final String? job;
  final String? character;
  final String name;
  final int id;
  final String? profilePath;

  @override
  List<Object?> get props => [
        job,
        character,
        name,
        id,
        profilePath,
      ];
}
