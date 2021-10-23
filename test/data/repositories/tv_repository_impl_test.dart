import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/models/crew_model.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_detail_episodes_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_detail_season_model.dart';
import 'package:ditonton/data/models/tv_episodes_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_seasons_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVRepositoryImpl repository;
  late MockTVRemoteDataSource mockRemoteDataSource;
  late MockTVLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVRemoteDataSource();
    mockLocalDataSource = MockTVLocalDataSource();
    repository = TVRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTVModel = TVModel(
    backdropPath: '/4QNBIgt5fwgNCN3OSU6BTFv0NGR.jpg',
    genreIds: [16, 10759],
    id: 888,
    name: 'Spider-Man',
    overview:
        'Bitten by a radioactive spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.',
    popularity: 82.967,
    posterPath: '/wXthtEN5kdWA1bHz03lkuCJS6hA.jpg',
    firstAirDate: '1994-11-19',
    originalName: 'Spider-Man',
    originalLanguage: "en",
    voteAverage: 8.3,
    voteCount: 633,
    originCountry: ["US"],
  );

  final tTV = TV(
    backdropPath: '/4QNBIgt5fwgNCN3OSU6BTFv0NGR.jpg',
    genreIds: [16, 10759],
    id: 888,
    name: 'Spider-Man',
    overview:
        'Bitten by a radioactive spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.',
    popularity: 82.967,
    posterPath: '/wXthtEN5kdWA1bHz03lkuCJS6hA.jpg',
    firstAirDate: '1994-11-19',
    originalName: 'Spider-Man',
    originalLanguage: "en",
    voteAverage: 8.3,
    voteCount: 633,
    originCountry: ["US"],
  );

  final tTVModelList = <TVModel>[tTVModel];
  final tTVList = <TV>[tTV];

  group('On The Air TVs', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getOnTheAirTV())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getOnTheAirTVs();
      // assert
      verify(mockRemoteDataSource.getOnTheAirTV());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getOnTheAirTV()).thenThrow(ServerException());
      // act
      final result = await repository.getOnTheAirTVs();
      // assert
      verify(mockRemoteDataSource.getOnTheAirTV());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getOnTheAirTV())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getOnTheAirTVs();
      // assert
      verify(mockRemoteDataSource.getOnTheAirTV());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular TV', () {
    test('should return TV list when call to data source is success', () async {
      // arrange
      when(mockRemoteDataSource.getPopularTV())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getPopularTVs();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTV()).thenThrow(ServerException());
      // act
      final result = await repository.getPopularTVs();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTV())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTVs();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated TVs', () {
    test('should return TV list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTV())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getTopRatedTVs();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTV()).thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTVs();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTV())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTVs();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get TV Detail', () {
    final tId = 1;
    final tTVResponse = TVDetailResponse(
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Action')],
      id: 1,
      originalName: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      numberOfSeasons: 1,
      numberOfEpisodes: 2,
      name: 'name',
      voteAverage: 1,
      voteCount: 1,
      episodeRunTime: [60],
      firstAirDate: "2021-12-01",
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

    test(
        'should return TV data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVDetail(tId))
          .thenAnswer((_) async => tTVResponse);
      // act
      final result = await repository.getTVDetails(tId);
      // assert
      verify(mockRemoteDataSource.getTVDetail(tId));
      expect(result, equals(Right(testTVDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVDetail(tId)).thenThrow(ServerException());
      // act
      final result = await repository.getTVDetails(tId);
      // assert
      verify(mockRemoteDataSource.getTVDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTVDetails(tId);
      // assert
      verify(mockRemoteDataSource.getTVDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
  group('Get TV Episodes Detail', () {
    final tId = 1;
    final tTVResponse = TVEpisodesModel(
      airDate: "2019-01-25",
      crew: [
        CrewModel(
            job: "Animation Director",
            character: "Basketball Captain (voice)",
            name: "Huang Feng",
            id: 2965969,
            profilePath: null)
      ],
      episodeNumber: 3,
      guestStars: [
        CrewModel(
            job: "Animation Director",
            character: "Basketball Captain (voice)",
            name: "Aina Suzuki",
            id: 1661870,
            profilePath: "/bRLwfft4yckDTpLenlbTrt3FRRN.jpg"),
        CrewModel(
            job: "Animation Director",
            character: "Beard Man (voice)",
            name: "Ryota Akazawa",
            id: 3211842,
            profilePath: null)
      ],
      name: "A Mountain of Problems",
      overview:
          "Nino isn't happy that Futaro is beginning to get along with her sisters, so she takes matters into her own hands.",
      id: 1659817,
      seasonNumber: 1,
      stillPath: "/vkuYEpktTjfZTZcl8XcChR0CN71.jpg",
    );

    test(
        'should return TV data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVEpisodesDetail(tId, tId, tId))
          .thenAnswer((_) async => tTVResponse);
      // act
      final result = await repository.getTVEpisodesDetail(tId, tId, tId);
      // assert
      verify(mockRemoteDataSource.getTVEpisodesDetail(tId, tId, tId));
      expect(result, equals(Right(testTVEpisodesDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVEpisodesDetail(tId, tId, tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTVEpisodesDetail(tId, tId, tId);
      // assert
      verify(mockRemoteDataSource.getTVEpisodesDetail(tId, tId, tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVEpisodesDetail(tId, tId, tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTVEpisodesDetail(tId, tId, tId);
      // assert
      verify(mockRemoteDataSource.getTVEpisodesDetail(tId, tId, tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get TV Seasons Detail', () {
    final tId = 1;
    final tTVResponse = TVSeasonsResponse(
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

    test(
        'should return TV data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVSeasonsDetail(tId, tId))
          .thenAnswer((_) async => tTVResponse);
      // act
      final result = await repository.getTVSeasonsDetail(tId, tId);
      // assert
      verify(mockRemoteDataSource.getTVSeasonsDetail(tId, tId));
      expect(result, equals(Right(testTVSeasonsDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVSeasonsDetail(tId, tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTVSeasonsDetail(tId, tId);
      // assert
      verify(mockRemoteDataSource.getTVSeasonsDetail(tId, tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVSeasonsDetail(tId, tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTVSeasonsDetail(tId, tId);
      // assert
      verify(mockRemoteDataSource.getTVSeasonsDetail(tId, tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get TV Recommendations', () {
    final tTVList = <TVModel>[];
    final tId = 1;

    test('should return data (tv list) when the call is successful', () async {
      // arrange
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenAnswer((_) async => tTVList);
      // act
      final result = await repository.getTVRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTVList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTVRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getTVRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTVRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach TVs', () {
    final tQuery = 'spiderman';

    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTV(tQuery))
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.searchTVs(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return TV ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTV(tQuery)).thenThrow(ServerException());
      // act
      final result = await repository.searchTVs(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTV(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTVs(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save tv watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertTVWatchlist(testTVTable))
          .thenAnswer((_) async => 'Added to TV Watchlist');
      // act
      final result = await repository.saveTVWatchlist(testTVDetail);
      // assert
      expect(result, Right('Added to TV Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertTVWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to add TV watchlist'));
      // act
      final result = await repository.saveTVWatchlist(testTVDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add TV watchlist')));
    });
  });

  group('remove tv watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeTVWatchlist(testTVTable))
          .thenAnswer((_) async => 'Removed from TV watchlist');
      // act
      final result = await repository.removeTVWatchlist(testTVDetail);
      // assert
      expect(result, Right('Removed from TV watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeTVWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to remove TV watchlist'));
      // act
      final result = await repository.removeTVWatchlist(testTVDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove TV watchlist')));
    });
  });

  group('get tv watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTVById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToTVWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist TVs', () {
    test('should return list of TVs', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTVs())
          .thenAnswer((_) async => [testTVTable]);
      // act
      final result = await repository.getWatchlistTVs();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTV]);
    });
  });
}
