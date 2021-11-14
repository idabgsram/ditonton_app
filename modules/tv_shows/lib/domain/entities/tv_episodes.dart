import 'package:core/core.dart';
import 'package:equatable/equatable.dart';


class TVEpisodes extends Equatable {
  TVEpisodes({
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
  final List<Crew> crew;
  final int episodeNumber;
  final List<Crew> guestStars;
  final String name;
  final String overview;
  final int id;
  final int seasonNumber;
  final String? stillPath;

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
