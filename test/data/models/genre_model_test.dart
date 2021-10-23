import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tGenreModel = GenreModel(
    id: 1,
    name: "name"
  );

  final tGenre = Genre(
    id: 1,
    name: "name"
  );

  test('should be a subclass of entity', () async {
    final result = tGenreModel.toEntity();
    expect(result, tGenre);
  });

  group('check fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/genre.json'));
      // act
      final result = GenreModel.fromJson(jsonMap);
      // assert
      expect(result, tGenreModel);
    });
  });

  group('check toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "id" : 1,
        "name": "name"
      };
      // act
      final result = tGenreModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
