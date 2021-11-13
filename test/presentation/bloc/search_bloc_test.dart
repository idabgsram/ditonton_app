import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/bloc/search_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTVs])
void main() {
  late SearchBloc searchBloc;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTVs mockSearchTVs;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockSearchTVs = MockSearchTVs();
    searchBloc = SearchBloc(mockSearchMovies, mockSearchTVs);
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchEmpty());
    expect(OnQueryChanged('').props, ['']);
    expect(OnRefreshChanged('Movies').props, ['Movies']);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];

  final tTVModel = TV(
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
  final tTVList = <TV>[tTVModel];
  final tQuery = 'spiderman';

  group('Search Movies test', () {
    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        SearchHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        SearchError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, HasData] when data is refreshed successfully',
      build: () {
        searchBloc.searchQuery = tQuery;
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return searchBloc;
      },
      act: (bloc) => [bloc.add(OnRefreshChanged('Movies'))],
      expect: () => [
        SearchLoading(),
        SearchHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, Error] when refresh is unsuccessful',
      build: () {
        searchBloc.searchQuery = tQuery;
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnRefreshChanged('Movies')),
      expect: () => [
        SearchLoading(),
        SearchError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, Empty] when query is empty',
      build: () {
        when(mockSearchMovies.execute('')).thenAnswer((_) async => Right([]));
        return searchBloc;
      },
      act: (bloc) => [bloc.add(OnQueryChanged(''))],
      expect: () => [
        SearchLoading(),
        SearchEmpty(),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(''));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, Empty] when query is empty on refresh',
      build: () {
        when(mockSearchMovies.execute('')).thenAnswer((_) async => Right([]));
        return searchBloc;
      },
      act: (bloc) => [bloc.add(OnRefreshChanged('Movies'))],
      expect: () => [
        SearchLoading(),
        SearchEmpty(),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(''));
      },
    );
  });

  group('Search TVs test', () {
    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        searchBloc.searchType = 'TV Shows';
        when(mockSearchTVs.execute(tQuery))
            .thenAnswer((_) async => Right(tTVList));
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        SearchHasData(tTVList),
      ],
      verify: (bloc) {
        verify(mockSearchTVs.execute(tQuery));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        searchBloc.searchType = 'TV Shows';
        when(mockSearchTVs.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        SearchError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchTVs.execute(tQuery));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, HasData] when data is refreshed successfully',
      build: () {
        searchBloc.searchQuery = tQuery;
        when(mockSearchTVs.execute(tQuery))
            .thenAnswer((_) async => Right(tTVList));
        return searchBloc;
      },
      act: (bloc) => [bloc.add(OnRefreshChanged('TV'))],
      expect: () => [
        SearchLoading(),
        SearchHasData(tTVList),
      ],
      verify: (bloc) {
        verify(mockSearchTVs.execute(tQuery));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, Error] when refresh is unsuccessful',
      build: () {
        searchBloc.searchQuery = tQuery;
        when(mockSearchTVs.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnRefreshChanged('TV')),
      expect: () => [
        SearchLoading(),
        SearchError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchTVs.execute(tQuery));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, Empty] when query is empty',
      build: () {
        searchBloc.searchType = 'TV Shows';
        when(mockSearchTVs.execute('')).thenAnswer((_) async => Right([]));
        return searchBloc;
      },
      act: (bloc) => [bloc.add(OnQueryChanged(''))],
      expect: () => [
        SearchLoading(),
        SearchEmpty(),
      ],
      verify: (bloc) {
        verify(mockSearchTVs.execute(''));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'Should emit [Loading, Empty] when query is empty on refresh',
      build: () {
        when(mockSearchTVs.execute('')).thenAnswer((_) async => Right([]));
        return searchBloc;
      },
      act: (bloc) => [bloc.add(OnRefreshChanged('TV'))],
      expect: () => [
        SearchLoading(),
        SearchEmpty(),
      ],
      verify: (bloc) {
        verify(mockSearchTVs.execute(''));
      },
    );
  });
}
