import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/home_ota_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/home_popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/home_top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTV, GetPopularTV, GetTopRatedTV])
void main() {
  late HomeOTATVBloc otaBloc;
  late HomePopularTVBloc popularBloc;
  late HomeTopRatedTVBloc topRatedBloc;
  late MockGetOnTheAirTV mockGetOnTheAirTVs;
  late MockGetPopularTV mockGetPopularTVs;
  late MockGetTopRatedTV mockGetTopRatedTVs;

  setUp(() {
    mockGetOnTheAirTVs = MockGetOnTheAirTV();
    mockGetPopularTVs = MockGetPopularTV();
    mockGetTopRatedTVs = MockGetTopRatedTV();
    otaBloc = HomeOTATVBloc(mockGetOnTheAirTVs);
    popularBloc = HomePopularTVBloc(mockGetPopularTVs);
    topRatedBloc = HomeTopRatedTVBloc(mockGetTopRatedTVs);
  });

  final tTV = TV(
    backdropPath: '/bAckDrop.jpg',
    genreIds: [1, 2, 3],
    id: 69,
    name: 'nameTV',
    overview: 'gang gang woo',
    popularity: 82.967,
    posterPath: '/teeeest.jpg',
    firstAirDate: '2021-10-19',
    originalName: 'nameTV',
    originalLanguage: 'id',
    voteAverage: 1,
    voteCount: 1,
    originCountry: [],
  );

  final tTVList = <TV>[tTV];

  group('On The Air TVs', () {
    test('initial state should be empty', () {
      expect(otaBloc.state, DataOTATVEmpty());
      expect(FetchOTATVData().props, []);
    });

    blocTest<HomeOTATVBloc, HomeOTATVState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetOnTheAirTVs.execute())
            .thenAnswer((_) async => Right(tTVList));
        return otaBloc;
      },
      act: (bloc) => bloc.add(FetchOTATVData()),
      expect: () => [
        DataOTATVLoading(),
        DataOTATVAvailable(tTVList),
      ],
      verify: (bloc) {
        verify(mockGetOnTheAirTVs.execute());
      },
    );

    blocTest<HomeOTATVBloc, HomeOTATVState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetOnTheAirTVs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return otaBloc;
      },
      act: (bloc) => bloc.add(FetchOTATVData()),
      expect: () => [
        DataOTATVLoading(),
        DataOTATVError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetOnTheAirTVs.execute());
      },
    );
  });

  group('popular TVs', () {
    test('initial state should be empty', () {
      expect(popularBloc.state, DataPopularTVEmpty());
      expect(FetchPopularTVData().props, []);
    });

    blocTest<HomePopularTVBloc, HomePopularTVState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetPopularTVs.execute())
            .thenAnswer((_) async => Right(tTVList));
        return popularBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTVData()),
      expect: () => [
        DataPopularTVLoading(),
        DataPopularTVAvailable(tTVList),
      ],
      verify: (bloc) {
        verify(mockGetPopularTVs.execute());
      },
    );

    blocTest<HomePopularTVBloc, HomePopularTVState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetPopularTVs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTVData()),
      expect: () => [
        DataPopularTVLoading(),
        DataPopularTVError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularTVs.execute());
      },
    );
  });

  group('top rated TVs', () {
    test('initial state should be empty', () {
      expect(topRatedBloc.state, DataTopRatedTVEmpty());
      expect(FetchTopRatedTVData().props, []);
    });

    blocTest<HomeTopRatedTVBloc, HomeTopRatedTVState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTVs.execute())
            .thenAnswer((_) async => Right(tTVList));
        return topRatedBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTVData()),
      expect: () => [
        DataTopRatedTVLoading(),
        DataTopRatedTVAvailable(tTVList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTVs.execute());
      },
    );

    blocTest<HomeTopRatedTVBloc, HomeTopRatedTVState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTopRatedTVs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTVData()),
      expect: () => [
        DataTopRatedTVLoading(),
        DataTopRatedTVError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTVs.execute());
      },
    );
  });
}
