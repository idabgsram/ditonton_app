import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:watchlist/domain/usecases/get_watchlist_movies.dart';
import 'package:watchlist/domain/usecases/get_watchlist_tv.dart';
import 'package:watchlist/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies, GetWatchlistTV])
void main() {
  late WatchlistMoviesBloc movieBloc;
  late WatchlistTVBloc tvBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchlistTV mockGetWatchlistTVs;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchlistTVs = MockGetWatchlistTV();
    movieBloc = WatchlistMoviesBloc(mockGetWatchlistMovies);
    tvBloc = WatchlistTVBloc(mockGetWatchlistTVs);
  });

  group('Watchlist Movies test', () {
    test('initial state should be empty', () {
      expect(movieBloc.state, DataEmpty());
      expect(GetWatchlistMoviesData().props, []);
    });

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Available] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        return movieBloc;
      },
      act: (bloc) => bloc.add(GetWatchlistMoviesData()),
      expect: () => [
        DataLoading(),
        DataAvailable([testWatchlistMovie]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return movieBloc;
      },
      act: (bloc) => bloc.add(GetWatchlistMoviesData()),
      expect: () => [
        DataLoading(),
        DataError('Database Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });

  group('Watchlist TVs test', () {
    test('initial state should be empty', () {
      expect(tvBloc.state, DataTVEmpty());
      expect(GetWatchlistTVData().props, []);
    });

    blocTest<WatchlistTVBloc, WatchlistTVState>(
      'Should emit [Loading, Available] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistTVs.execute())
            .thenAnswer((_) async => Right([testWatchlistTV]));
        return tvBloc;
      },
      act: (bloc) => bloc.add(GetWatchlistTVData()),
      expect: () => [
        DataTVLoading(),
        DataTVAvailable([testWatchlistTV]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTVs.execute());
      },
    );

    blocTest<WatchlistTVBloc, WatchlistTVState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetWatchlistTVs.execute())
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return tvBloc;
      },
      act: (bloc) => bloc.add(GetWatchlistTVData()),
      expect: () => [
        DataTVLoading(),
        DataTVError('Database Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTVs.execute());
      },
    );
  });
}
