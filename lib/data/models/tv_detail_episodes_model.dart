import 'package:ditonton/domain/entities/tv_detail_episodes.dart';
import 'package:equatable/equatable.dart';

class TVDetailEpisodesModel extends Equatable {
  TVDetailEpisodesModel({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.stillPath,
  });

  final String airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final String? stillPath;

  factory TVDetailEpisodesModel.fromJson(Map<String, dynamic> json) =>
      TVDetailEpisodesModel(
        airDate: json["air_date"],
        episodeNumber: json["episode_number"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        stillPath: json["still_path"],
      );

  Map<String, dynamic> toJson() => {
        "air_date": airDate,
        "episode_number": episodeNumber,
        "id": id,
        "name": name,
        "overview": overview,
        "still_path": stillPath,
      };
  TVDetailEpisodes toEntity() {
    return TVDetailEpisodes(
      airDate: this.airDate,
      episodeNumber: this.episodeNumber,
      id: this.id,
      name: this.name,
      overview: this.overview,
      stillPath: this.stillPath,
    );
  }

  @override
  List<Object?> get props => [
        airDate,
        episodeNumber,
        id,
        name,
        overview,
        stillPath,
      ];
}
