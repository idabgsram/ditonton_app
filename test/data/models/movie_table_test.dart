import 'dart:convert';

import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tMovieModel = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovie = Movie.watchlist(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );


  test('should be a subclass of Movie entity', () async {
    final result = tMovieModel.toEntity();
    expect(result, tMovie);
  });

  group('check fromEntity', () {
    test('should return a valid model from Entity', () async {
      // arrange
      final testMovieDetail = MovieDetail(
        adult: false,
        backdropPath: 'backdropPath',
        genres: [Genre(id: 1, name: 'Action')],
        id: 1,
        originalTitle: 'originalTitle',
        overview: 'overview',
        posterPath: 'posterPath',
        releaseDate: 'releaseDate',
        runtime: 120,
        title: 'title',
        voteAverage: 1,
        voteCount: 1,
      );
      // act
      final result = MovieTable.fromEntity(testMovieDetail);
      // assert
      expect(result, tMovieModel);
    });
  });

  group('check fromMap', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/table.json'));
      // act
      final result = MovieTable.fromMap(jsonMap);
      // assert
      expect(result, tMovieModel);
    });
  });

  group('check toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "id": 1,
        "title": "title",
        "posterPath": "posterPath",
        "overview": "overview",
      };
      // act
      final result = tMovieModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
