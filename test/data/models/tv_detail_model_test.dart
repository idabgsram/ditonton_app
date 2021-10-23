import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_detail_episodes_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_detail_season_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_detail_episodes.dart';
import 'package:ditonton/domain/entities/tv_detail_season.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTVModel = TVDetailResponse(
    backdropPath: 'backdropPath',
    genres: [GenreModel(id: 1, name: 'Action')],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    numberOfSeasons: 1,
    numberOfEpisodes: 2,
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
    episodeRunTime: [60],
    firstAirDate: "2015-08-23",
    inProduction: true,
    lastEpisodeToAir: TVDetailEpisodesModel(
        airDate: "2002-12-01",
        episodeNumber: 1,
        id: 1,
        name: "name",
        overview: "overview",
        stillPath: "stillPath"),
    nextEpisodeToAir: TVDetailEpisodesModel(
        airDate: "2002-12-08",
        episodeNumber: 2,
        id: 2,
        name: "name",
        overview: "overview",
        stillPath: "stillPath"),
    seasons: [
      TVDetailSeasonModel(
          airDate: "airDate",
          episodeCount: 2,
          id: 1,
          name: "name",
          overview: "overview",
          posterPath: "posterPath",
          seasonNumber: 1)
    ],
    type: "type",
  );

  final tTV = TVDetail(
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    numberOfSeasons: 1,
    numberOfEpisodes: 2,
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
    episodeRunTime: [60],
    firstAirDate: "2015-08-23",
    inProduction: true,
    lastEpisodeToAir: TVDetailEpisodes(
        airDate: "2002-12-01",
        episodeNumber: 1,
        id: 1,
        name: "name",
        overview: "overview",
        stillPath: "stillPath"),
    nextEpisodeToAir: TVDetailEpisodes(
        airDate: "2002-12-08",
        episodeNumber: 2,
        id: 2,
        name: "name",
        overview: "overview",
        stillPath: "stillPath"),
    seasons: [
      TVDetailSeason(
          airDate: "airDate",
          episodeCount: 2,
          id: 1,
          name: "name",
          overview: "overview",
          posterPath: "posterPath",
          seasonNumber: 1)
    ],
    type: "type",
  );

  test('should be a subclass of entity', () async {
    final result = tTVModel.toEntity();
    expect(result, tTV);
  });

  group('check fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_detail.json'));
      // act
      final result = TVDetailResponse.fromJson(jsonMap);
      // assert
      expect(result, tTVModel);
    });
  });

  group('check toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "backdrop_path": "backdropPath",
        "episode_run_time": [60],
        "first_air_date": "2015-08-23",
        "genres": [
          {"id": 1, "name": "Action"}
        ],
        "id": 1,
        "in_production": true,
        "last_episode_to_air": {
          "air_date": "2002-12-01",
          "episode_number": 1,
          "id": 1,
          "name": "name",
          "overview": "overview",
          "still_path": "stillPath"
        },
        "name": "name",
        "next_episode_to_air": {
          "air_date": "2002-12-08",
          "episode_number": 2,
          "id": 2,
          "name": "name",
          "overview": "overview",
          "still_path": "stillPath"
        },
        "number_of_episodes": 2,
        "number_of_seasons": 1,
        "original_name": "originalName",
        "overview": "overview",
        "popularity": 1,
        "poster_path": "posterPath",
        "seasons": [
          {
            "air_date": "airDate",
            "episode_count": 2,
            "id": 1,
            "name": "name",
            "overview": "overview",
            "poster_path": "posterPath",
            "season_number": 1
          }
        ],
        "type": "type",
        "vote_average": 1,
        "vote_count": 1
      };
      // act
      final result = tTVModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
