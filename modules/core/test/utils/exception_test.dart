import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/data/datasources/movie_local_data_source.dart';
import 'package:movies/data/repository/movie_repository_impl.dart';

import '../dummy_data/dummy_objects.dart';
import '../helpers/test_helper.mocks.dart';

void main() {
  late MockDatabaseHelper mockDatabaseHelper;
  late MovieLocalDataSourceImpl dataSource;
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockRemoteDataSource = MockMovieRemoteDataSource();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
    mockLocalDataSource = MockMovieLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  group('Exception test', () {
    test('Throw DatabaseException test', () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlist(testMovieTable))
          .thenThrow(DatabaseException(''));
      // act
      final call = dataSource.insertWatchlist(testMovieTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });

    test('Throw CacheException test', () async {
      // arrange
      when(mockDatabaseHelper.getCacheMovies('nowplaying'))
          .thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedMovies('nowplaying');
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });

  group('Failure test', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('CacheFailure tests', () async {
      // arrange
      when(mockLocalDataSource.getCachedMovies('popular'))
          .thenThrow(CacheException('No Cache'));
      // act
      final result = await repository.getPopularMovies();
      // assert
      verify(mockLocalDataSource.getCachedMovies('popular'));
      expect(result, Left(CacheFailure('No Cache')));
    });

    test('DatabaseFailure tests', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testMovieDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });

    test('ServerFailure tests', () async {
      // arrange
      when(mockRemoteDataSource.getMovieRecommendations(1))
          .thenThrow(ServerException());
      // act
      final result = await repository.getMovieRecommendations(1);
      // assert
      verify(mockRemoteDataSource.getMovieRecommendations(1));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('ConnectionFailure tests', () async {
      // arrange
      when(mockRemoteDataSource.getMovieDetail(1))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getMovieDetail(1);
      // assert
      verify(mockRemoteDataSource.getMovieDetail(1));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
}
