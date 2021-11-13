import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MovieDetailRecommendationsBloc recommendationsBloc;
  late MovieDetailWatchlistBloc watchlistBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = MovieDetailBloc(mockGetMovieDetail);
    recommendationsBloc =
        MovieDetailRecommendationsBloc(mockGetMovieRecommendations);
    watchlistBloc = MovieDetailWatchlistBloc(
        mockSaveWatchlist, mockRemoveWatchlist, mockGetWatchlistStatus);
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  group('Get Movie Detail', () {
    test('initial state should be empty', () {
      expect(bloc.state, DataEmpty());
      expect(FetchDetailData(tId).props, [tId]);
    });

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Available] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchDetailData(tId)),
      expect: () => [
        DataLoading(),
        DataAvailable(testMovieDetail),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchDetailData(tId)),
      expect: () => [
        DataLoading(),
        DataError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );
  });

  group('Get Movie Recommendations', () {
    test('initial state should be empty', () {
      expect(recommendationsBloc.state, DataRecommendationsEmpty());
      expect(FetchRecommendationsData(tId).props, [tId]);
    });

    blocTest<MovieDetailRecommendationsBloc, MovieDetailRecommendationsState>(
      'Should emit [Loading, Available] when data is gotten successfully',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return recommendationsBloc;
      },
      act: (bloc) => bloc.add(FetchRecommendationsData(tId)),
      expect: () => [
        DataRecommendationsLoading(),
        DataRecommendationsAvailable(tMovies),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieDetailRecommendationsBloc, MovieDetailRecommendationsState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return recommendationsBloc;
      },
      act: (bloc) => bloc.add(FetchRecommendationsData(tId)),
      expect: () => [
        DataRecommendationsLoading(),
        DataRecommendationsError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });

  group('Watchlist', () {
    test('initial state should be empty', () {
      expect(watchlistBloc.state, StatusReceived(false, ''));
      expect(AddWatchlist(testMovieDetail).props, [testMovieDetail]);
      expect(RemoveFromWatchlist(testMovieDetail).props, [testMovieDetail]);
      expect(LoadWatchlistStatus(tId).props, [tId]);
    });

    blocTest<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
      'Should emit [Received] when data is saved successfully',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async =>
            Right(MovieDetailWatchlistBloc.watchlistAddSuccessMessage));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
      expect: () => [
        StatusLoading(),
        StatusReceived(
            true, MovieDetailWatchlistBloc.watchlistAddSuccessMessage),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
      'Should emit [Error] when save data is unsuccessful',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
      expect: () => [
        StatusLoading(),
        StatusError('Database Failure'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
      'Should emit [Received] when data is removed successfully',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async =>
                Right(MovieDetailWatchlistBloc.watchlistRemoveSuccessMessage));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
      expect: () => [
        StatusLoading(),
        StatusReceived(
            false, MovieDetailWatchlistBloc.watchlistRemoveSuccessMessage),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
      'Should emit [Error] when remove data is unsuccessful',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
      expect: () => [
        StatusLoading(),
        StatusError('Database Failure'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
      },
    );
    blocTest<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
      'Should emit [Received] when get status',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(tId)),
      expect: () => [
        StatusReceived(true, ''),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });
}
