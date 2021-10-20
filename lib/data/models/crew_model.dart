import 'package:ditonton/domain/entities/crew.dart';
import 'package:equatable/equatable.dart';

class CrewModel extends Equatable {
  CrewModel({
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

  factory CrewModel.fromJson(Map<String, dynamic> json) => CrewModel(
        job: json["job"],
        character: json["character"],
        name: json["name"],
        id: json["id"],
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "job": job,
        "character": character,
        "name": name,
        "id": id,
        "profile_path": profilePath,
      };
  Crew toEntity() {
    return Crew(
      job: this.job,
      character: this.character,
      name: this.name,
      id: this.id,
      profilePath: this.profilePath,
    );
  }

  @override
  List<Object?> get props => [
        job,
        character,
        name,
        id,
        profilePath,
      ];
}
