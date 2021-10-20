import 'package:equatable/equatable.dart';

class TVDetailEpisodes extends Equatable {
  TVDetailEpisodes({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.stillPath,
    required this.overview,
  });

  final String? airDate;
  final int? episodeNumber;
  final int id;
  final String? name;
  final String? stillPath;
  final String? overview;

  @override
  List<Object?> get props =>
      [airDate, episodeNumber, id, name, overview, stillPath];
}
