import 'dart:convert';

import 'package:ditonton/data/models/crew_model.dart';
import 'package:ditonton/data/models/tv_episodes_model.dart';
import 'package:ditonton/data/models/tv_seasons_model.dart';
import 'package:ditonton/domain/entities/crew.dart';
import 'package:ditonton/domain/entities/tv_episodes.dart';
import 'package:ditonton/domain/entities/tv_seasons.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTVSeasonsModel = TVSeasonsResponse(
    episodes: [
      TVEpisodesModel(
          airDate: "2006-09-18",
          crew: [],
          episodeNumber: 1,
          guestStars: [
            CrewModel(
                job: "Animation Director",
                character: "",
                name: "Diane Sawyer",
                id: 1215497,
                profilePath: "/9CDV3wzGxIVF2vBFk2WV0Z3SCab.jpg")
          ],
          name: "Rachael's Premiere",
          overview: "",
          id: 135844,
          seasonNumber: 1,
          stillPath: null)
    ],
    airDate: "2006-09-18",
    name: "Season 1",
    overview: "",
    id: 5904,
    itemId: "52571e1819c2957114101a1a",
    seasonNumber: 1,
    posterPath: null,
  );

  final tTVSeasons = TVSeasons(
    episodes: [
      TVEpisodes(
          airDate: "2006-09-18",
          crew: [],
          episodeNumber: 1,
          guestStars: [
            Crew(
                job: "Animation Director",
                character: "",
                name: "Diane Sawyer",
                id: 1215497,
                profilePath: "/9CDV3wzGxIVF2vBFk2WV0Z3SCab.jpg")
          ],
          name: "Rachael's Premiere",
          overview: "",
          id: 135844,
          seasonNumber: 1,
          stillPath: null)
    ],
    airDate: "2006-09-18",
    name: "Season 1",
    overview: "",
    id: 5904,
    itemId: "52571e1819c2957114101a1a",
    seasonNumber: 1,
    posterPath: null,
  );

  test('should be a subclass of TV entity', () async {
    final result = tTVSeasonsModel.toEntity();
    expect(result, tTVSeasons);
  });

  group('check fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_seasons.json'));
      // act
      final result = TVSeasonsResponse.fromJson(jsonMap);
      // assert
      expect(result, tTVSeasonsModel);
    });
  });

  group('check toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "_id": "52571e1819c2957114101a1a",
        "air_date": "2006-09-18",
        "episodes": [
          {
            "air_date": "2006-09-18",
            "episode_number": 1,
            "crew": [],
            "guest_stars": [
              {
                "job": "Animation Director",
                "character": "",
                "id": 1215497,
                "name": "Diane Sawyer",
                "profile_path": "/9CDV3wzGxIVF2vBFk2WV0Z3SCab.jpg"
              }
            ],
            "id": 135844,
            "name": "Rachael's Premiere",
            "overview": "",
            "season_number": 1,
            "still_path": null
          }
        ],
        "name": "Season 1",
        "overview": "",
        "id": 5904,
        "poster_path": null,
        "season_number": 1
      };
      // act
      final result = tTVSeasonsModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
