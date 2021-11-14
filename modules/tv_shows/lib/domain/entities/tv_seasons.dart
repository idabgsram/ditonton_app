import 'package:tv_shows/domain/entities/tv_episodes.dart';
import 'package:equatable/equatable.dart';

class TVSeasons extends Equatable {
  TVSeasons({
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
  final List<TVEpisodes> episodes;
  final String name;
  final String overview;
  final int id;
  final String? posterPath;
  final int seasonNumber;

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
