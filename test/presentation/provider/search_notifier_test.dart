import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_notifier_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTVs])
void main() {
  late SearchNotifier provider;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTVs mockSearchTVs;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchMovies = MockSearchMovies();
    mockSearchTVs = MockSearchTVs();
    provider =
        SearchNotifier(searchMovies: mockSearchMovies, searchTVs: mockSearchTVs)
          ..addListener(() {
            listenerCallCount += 1;
          });
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
  final tQuery = 'spiderman';

  group('search movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await provider.fetchSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

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
  final tTVQuery = 'spiderman';
  group('search TVs', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      provider.setCurrentSelection('TV Shows');
      when(mockSearchTVs.execute(tTVQuery))
          .thenAnswer((_) async => Right(tTVList));
      // act
      provider.fetchSearch(tTVQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      provider.setCurrentSelection('TV Shows');
      when(mockSearchTVs.execute(tTVQuery))
          .thenAnswer((_) async => Right(tTVList));
      // act
      await provider.fetchSearch(tTVQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tTVList);
      expect(listenerCallCount, 3);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      provider.setCurrentSelection('TV Shows');
      when(mockSearchTVs.execute(tTVQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchSearch(tTVQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 3);
    });
  });
}
