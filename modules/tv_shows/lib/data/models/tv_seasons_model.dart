import 'package:tv_shows/data/models/tv_episodes_model.dart';
import 'package:tv_shows/domain/entities/tv_seasons.dart';
import 'package:equatable/equatable.dart';

class TVSeasonsResponse extends Equatable {
  TVSeasonsResponse({
    required this.itemId,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.id,
    required this.posterPath,
    required this.seasonNumber,
  });

  final String itemId;
  final String? airDate;
  final List<TVEpisodesModel> episodes;
  final String name;
  final String overview;
  final int id;
  final String? posterPath;
  final int seasonNumber;

  factory TVSeasonsResponse.fromJson(Map<String, dynamic> json) =>
      TVSeasonsResponse(
        itemId: json["_id"],
        airDate: json["air_date"],
        episodes: List<TVEpisodesModel>.from(
            json["episodes"].map((x) => TVEpisodesModel.fromJson(x))),
        name: json["name"],
        overview: json["overview"],
        id: json["id"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "_id": itemId,
        "air_date": airDate,
        "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
        "name": name,
        "overview": overview,
        "id": id,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };
  TVSeasons toEntity() {
    return TVSeasons(
      itemId: this.itemId,
      airDate: this.airDate,
      episodes: this.episodes.map((episodes) => episodes.toEntity()).toList(),
      name: this.name,
      overview: this.overview,
      id: this.id,
      posterPath: this.posterPath,
      seasonNumber: this.seasonNumber,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        airDate,
        episodes,
        name,
        overview,
        id,
        posterPath,
        seasonNumber,
      ];
}
