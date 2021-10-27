import 'package:ditonton/data/models/crew_model.dart';
import 'package:ditonton/domain/entities/tv_episodes.dart';
import 'package:equatable/equatable.dart';

class TVEpisodesModel extends Equatable {
  TVEpisodesModel({
    required this.airDate,
    required this.crew,
    required this.episodeNumber,
    required this.guestStars,
    required this.name,
    required this.overview,
    required this.id,
    required this.seasonNumber,
    required this.stillPath,
  });

  final String? airDate;
  final List<CrewModel> crew;
  final int episodeNumber;
  final List<CrewModel> guestStars;
  final String name;
  final String overview;
  final int id;
  final int seasonNumber;
  final String? stillPath;

  factory TVEpisodesModel.fromJson(Map<String, dynamic> json) =>
      TVEpisodesModel(
        airDate: json["air_date"],
        crew: List<CrewModel>.from(
            json["crew"].map((x) => CrewModel.fromJson(x))),
        episodeNumber: json["episode_number"],
        guestStars: List<CrewModel>.from(
            json["guest_stars"].map((x) => CrewModel.fromJson(x))),
        name: json["name"],
        overview: json["overview"],
        id: json["id"],
        seasonNumber: json["season_number"],
        stillPath: json["still_path"],
      );

  Map<String, dynamic> toJson() => {
        "air_date": airDate,
        "crew":List<dynamic>.from(crew.map((x) => x.toJson())),
        "episode_number": episodeNumber,
        "guest_stars": List<dynamic>.from(guestStars.map((x) => x.toJson())),
        "name": name,
        "overview": overview,
        "id": id,
        "season_number": seasonNumber,
        "still_path": stillPath,
      };
  TVEpisodes toEntity() {
    return TVEpisodes(
      airDate: this.airDate,
      crew: this.crew.map((crew) => crew.toEntity()).toList(),
      episodeNumber: this.episodeNumber,
      guestStars:
          this.guestStars.map((guestStars) => guestStars.toEntity()).toList(),
      name: this.name,
      overview: this.overview,
      id: this.id,
      seasonNumber: this.seasonNumber,
      stillPath: this.stillPath,
    );
  }

  @override
  List<Object?> get props => [
        airDate,
        crew,
        episodeNumber,
        guestStars,
        name,
        overview,
        id,
        seasonNumber,
        stillPath,
      ];
}
