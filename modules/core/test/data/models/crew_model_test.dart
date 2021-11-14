import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tCrewModel = CrewModel(
    job: "job",
    character: "character",
    name: "name",
    id: 1,
    profilePath: "profilePath",
  );

  final tCrew = Crew(
    job: "job",
    character: "character",
    name: "name",
    id: 1,
    profilePath: "profilePath",
  );

  test('should be a subclass of Crew entity', () async {
    final result = tCrewModel.toEntity();
    expect(result, tCrew);
  });

  group('check fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/crew.json'));
      // act
      final result = CrewModel.fromJson(jsonMap);
      // assert
      expect(result, tCrewModel);
    });
  });

  group('check toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "job": "job",
        "character": "character",
        "name": "name",
        "id": 1,
        "profile_path": "profilePath"
      };
      // act
      final result = tCrewModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
