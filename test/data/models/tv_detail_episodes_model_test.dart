import 'dart:convert';

import 'package:ditonton/data/models/tv_detail_episodes_model.dart';
import 'package:ditonton/data/models/tv_seasons_model.dart';
import 'package:ditonton/domain/entities/tv_detail_episodes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tModel = TVDetailEpisodesModel(
    airDate: "2006-09-18",
    name: "Episode 1",
    overview: "",
    id: 59041,
    episodeNumber: 1,
    stillPath: "stillPath",
  );

  final tEntities = TVDetailEpisodes(
    airDate: "2006-09-18",
    name: "Episode 1",
    overview: "",
    id: 59041,
    episodeNumber: 1,
    stillPath: "stillPath",
  );

  test('should be a subclass of the entity', () async {
    final result = tModel.toEntity();
    expect(result, tEntities);
  });

  group('check fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_episodes_detail.json'));
      // act
      final result = TVDetailEpisodesModel.fromJson(jsonMap);
      // assert
      expect(result, tModel);
    });
  });

  group('check toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "air_date": "2006-09-18",
        "name": "Episode 1",
        "overview": "",
        "id": 59041,
        "still_path": "stillPath",
        "episode_number": 1
      };
      // act
      final result = tModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
