import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv_shows/domain/entities/tv.dart';
import 'package:tv_shows/domain/usecases/get_on_the_air_tv.dart';
import 'package:tv_shows/presentation/bloc/ota_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ota_tv_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTV])
void main() {
  late MockGetOnTheAirTV mockGetOnTheAirTV;
  late OTATVBloc bloc;

  setUp(() {
    mockGetOnTheAirTV = MockGetOnTheAirTV();
    bloc = OTATVBloc(mockGetOnTheAirTV);
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

  test('initial state should be empty', () {
    expect(bloc.state, DataEmpty());
    expect(FetchData().props, []);
  });

  blocTest<OTATVBloc, OTATVState>(
    'Should emit [Loading, Available] when data is gotten successfully',
    build: () {
      when(mockGetOnTheAirTV.execute())
          .thenAnswer((_) async => Right(tTVList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchData()),
    expect: () => [
      DataLoading(),
      DataAvailable(tTVList),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTV.execute());
    },
  );

  blocTest<OTATVBloc, OTATVState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetOnTheAirTV.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchData()),
    expect: () => [
      DataLoading(),
      DataError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTV.execute());
    },
  );

}
