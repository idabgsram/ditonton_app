import 'dart:convert';

import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  final tTVModel = TVTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tTV = TV.watchlist(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );


  test('should be a subclass of the entity', () async {
    final result = tTVModel.toEntity();
    expect(result, tTV);
  });

  group('check fromEntity', () {
    test('should return a valid model from Entity', () async {
      // arrange

      // act
      final result = TVTable.fromEntity(testTVDetail);
      // assert
      expect(result, tTVModel);
    });
  });

  group('check fromMap', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/table.json'));
      // act
      final result = TVTable.fromMap(jsonMap);
      // assert
      expect(result, tTVModel);
    });
  });

  group('check toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "id": 1,
        "name": "name",
        "posterPath": "posterPath",
        "overview": "overview",
      };
      // act
      final result = tTVModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
