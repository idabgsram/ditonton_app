import 'dart:convert';

import 'package:tv_shows/data/models/tv_detail_season_model.dart';
import 'package:tv_shows/domain/entities/tv_detail_season.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tModel = TVDetailSeasonModel(
    airDate: "2006-09-18",
    name: "Season 1",
    overview: "",
    id: 5904,
    episodeCount: 1,
    seasonNumber: 1,
    posterPath: "posterPath",
  );

  final tEntities = TVDetailSeason(
    airDate: "2006-09-18",
    name: "Season 1",
    overview: "",
    id: 5904,
    episodeCount: 1,
    seasonNumber: 1,
    posterPath: "posterPath",
  );

  test('should be a subclass of the entity', () async {
    final result = tModel.toEntity();
    expect(result, tEntities);
  });

  group('check fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_seasons_detail.json'));
      // act
      final result = TVDetailSeasonModel.fromJson(jsonMap);
      // assert
      expect(result, tModel);
    });
  });

  group('check toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "episode_count": 1,
        "air_date": "2006-09-18",
        "name": "Season 1",
        "overview": "",
        "id": 5904,
        "poster_path": "posterPath",
        "season_number": 1
      };
      // act
      final result = tModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
