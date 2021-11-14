import 'dart:convert';

import 'package:tv_shows/data/datasources/tv_remote_data_source.dart';
import 'package:core/core.dart';
import 'package:tv_shows/data/models/tv_detail_model.dart';
import 'package:tv_shows/data/models/tv_episodes_model.dart';
import 'package:tv_shows/data/models/tv_response.dart';
import 'package:tv_shows/data/models/tv_seasons_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=76315bd76ea937981aa95c14d71bbac8';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TVRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVRemoteDataSourceImpl(client:mockHttpClient);
  });

  group('get On The Air TVs', () {
    final tTVList =
        TVResponse.fromJson(json.decode(readJson('dummy_data/tv_ota.json')))
            .tvList;

    test('should return list of TV Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_ota.json'), 200));
      // act
      final result = await dataSource.getOnTheAirTV();
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getOnTheAirTV();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TVs', () {
    final tTVList =
        TVResponse.fromJson(json.decode(readJson('dummy_data/tv_ota.json')))
            .tvList;

    test('should return list of TV when response is success (200)', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_ota.json'), 200));
      // act
      final result = await dataSource.getPopularTV();
      // assert
      expect(result, tTVList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTV();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV', () {
    final tTVList =
        TVResponse.fromJson(json.decode(readJson('dummy_data/tv_ota.json')))
            .tvList;

    test('should return list of TV when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_ota.json'), 200));
      // act
      final result = await dataSource.getTopRatedTV();
      // assert
      expect(result, tTVList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTV();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV detail', () {
    final tId = 1;
    final tTVDetail = TVDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200));
      // act
      final result = await dataSource.getTVDetail(tId);
      // assert
      expect(result, equals(tTVDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTVDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv recommendations', () {
    final tTVList =
        TVResponse.fromJson(json.decode(readJson('dummy_data/tv_ota.json')))
            .tvList;
    final tId = 1;

    test('should return list of TV Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_ota.json'), 200));
      // act
      final result = await dataSource.getTVRecommendations(tId);
      // assert
      expect(result, equals(tTVList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTVRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv episodes detail', () {
    final tTVResponse = TVEpisodesModel.fromJson(
        json.decode(readJson('dummy_data/tv_episodes.json')));
    final tId = 1;

    test('should return list of TV Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(
              Uri.parse('$BASE_URL/tv/$tId/season/$tId/episode/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_episodes.json'), 200));
      // act
      final result = await dataSource.getTVEpisodesDetail(tId, tId, tId);
      // assert
      expect(result, equals(tTVResponse));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
              Uri.parse('$BASE_URL/tv/$tId/season/$tId/episode/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTVEpisodesDetail(tId, tId, tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv seasons detail', () {
    final tTVResponse = TVSeasonsResponse.fromJson(
        json.decode(readJson('dummy_data/tv_seasons.json')));
    final tId = 1;

    test('should return list of TV Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/season/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_seasons.json'), 200));
      // act
      final result = await dataSource.getTVSeasonsDetail(tId, tId);
      // assert
      expect(result, equals(tTVResponse));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/season/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTVSeasonsDetail(tId, tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv', () {
    final tSearchResult = TVResponse.fromJson(
            json.decode(readJson('dummy_data/search_spiderman_tv.json')))
        .tvList;
    final tQuery = 'Spiderman';

    test('should return list of tv when response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_spiderman_tv.json'), 200));
      // act
      final result = await dataSource.searchTV(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTV(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
