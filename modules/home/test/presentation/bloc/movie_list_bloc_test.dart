import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:core/core.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:home/presentation/bloc/home_now_playing_movies_bloc.dart';
import 'package:home/presentation/bloc/home_popular_movies_bloc.dart';
import 'package:home/presentation/bloc/home_top_rated_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late HomeNowPlayingMoviesBloc nowPlayingBloc;
  late HomePopularMoviesBloc popularBloc;
  late HomeTopRatedMoviesBloc topRatedBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    nowPlayingBloc = HomeNowPlayingMoviesBloc(
      mockGetNowPlayingMovies,
    );
    popularBloc = HomePopularMoviesBloc(
      mockGetPopularMovies,
    );
    topRatedBloc = HomeTopRatedMoviesBloc(
      mockGetTopRatedMovies,
    );
  });

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
  final tMovieList = <Movie>[tMovie];

  group('now playing movies', () {
    test('initial state should be empty', () {
      expect(nowPlayingBloc.state, DataNowPlayingMoviesEmpty());
      expect(FetchNowPlayingMoviesData().props, []);
    });

    blocTest<HomeNowPlayingMoviesBloc, HomeNowPlayingMoviesState>(
      'Should emit [Loading, Available] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return nowPlayingBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMoviesData()),
      expect: () => [
        DataNowPlayingMoviesLoading(),
        DataNowPlayingMoviesAvailable(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<HomeNowPlayingMoviesBloc, HomeNowPlayingMoviesState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return nowPlayingBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMoviesData()),
      expect: () => [
        DataNowPlayingMoviesLoading(),
        DataNowPlayingMoviesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });

  group('popular movies', () {
    test('initial state should be empty', () {
      expect(popularBloc.state, DataPopularMoviesEmpty());
      expect(FetchPopularMoviesData().props, []);
    });

    blocTest<HomePopularMoviesBloc, HomePopularMoviesState>(
      'Should emit [Loading, Available] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return popularBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMoviesData()),
      expect: () => [
        DataPopularMoviesLoading(),
        DataPopularMoviesAvailable(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<HomePopularMoviesBloc, HomePopularMoviesState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMoviesData()),
      expect: () => [
        DataPopularMoviesLoading(),
        DataPopularMoviesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });

  group('top rated movies', () {
    test('initial state should be empty', () {
      expect(topRatedBloc.state, DataTopRatedMoviesEmpty());
      expect(FetchTopRatedMoviesData().props, []);
    });

    blocTest<HomeTopRatedMoviesBloc, HomeTopRatedMoviesState>(
      'Should emit [Loading, Available] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return topRatedBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMoviesData()),
      expect: () => [
        DataTopRatedMoviesLoading(),
        DataTopRatedMoviesAvailable(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<HomeTopRatedMoviesBloc, HomeTopRatedMoviesState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMoviesData()),
      expect: () => [
        DataTopRatedMoviesLoading(),
        DataTopRatedMoviesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });
}
