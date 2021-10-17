
import 'package:ditonton/domain/entities/tv_episodes.dart';
import 'package:equatable/equatable.dart';

class TVEpisodesModel extends Equatable {
    TVEpisodesModel({
        required this.airDate,
        required this.episodeNumber,
        required this.id,
        required this.name,
        required this.overview,
        required this.productionCode,
        required this.seasonNumber,
        required this.stillPath,
        required this.voteAverage,
        required this.voteCount,
    });

    final String airDate;
    final int episodeNumber;
    final int id;
    final String name;
    final String overview;
    final String productionCode;
    final int seasonNumber;
    final String? stillPath;
    final double voteAverage;
    final int voteCount;

    factory TVEpisodesModel.fromJson(Map<String, dynamic> json) => TVEpisodesModel(
        airDate:json["air_date"],
        episodeNumber: json["episode_number"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        productionCode: json["production_code"],
        seasonNumber: json["season_number"],
        stillPath: json["still_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
    );

    Map<String, dynamic> toJson() => {
        "air_date": airDate,
        "episode_number": episodeNumber,
        "id": id,
        "name": name,
        "overview": overview,
        "production_code": productionCode,
        "season_number": seasonNumber,
        "still_path": stillPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
    TVEpisodes toEntity() {
     return TVEpisodes(
        airDate: this.airDate,
        episodeNumber: this.episodeNumber,
        id: this.id,
        name: this.name,
        overview: this.overview,
        productionCode: this.productionCode,
        seasonNumber: this.seasonNumber,
        stillPath: this.stillPath,
        voteAverage: this.voteAverage,
        voteCount: this.voteCount,
     );
    }

    @override
    List<Object?> get props => [
        airDate,
        episodeNumber,
        id,
        name,
        overview,
        productionCode,
        seasonNumber,
        stillPath,
        voteAverage,
        voteCount,
     ];
}