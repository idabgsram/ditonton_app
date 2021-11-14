import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv_shows/domain/usecases/get_tv_seasons_detail.dart';
import 'package:tv_shows/presentation/bloc/tv_seasons_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_seasons_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVSeasonsDetail,
])
void main() {
  late TVSeasonsDetailBloc bloc;
  late MockGetTVSeasonsDetail mockGetTVSeasonsDetail;

  setUp(() {
    mockGetTVSeasonsDetail = MockGetTVSeasonsDetail();
    bloc = TVSeasonsDetailBloc(mockGetTVSeasonsDetail);
  });

  final tId = 1;

  group('Get TV Detail', () {
    test('initial state should be empty', () {
      expect(bloc.state, DataEmpty());
      expect(FetchData(tId, tId).props, [tId, tId]);
    });

    blocTest<TVSeasonsDetailBloc, TVSeasonsDetailState>(
      'Should emit [Loading, Available] when data is gotten successfully',
      build: () {
        when(mockGetTVSeasonsDetail.execute(tId, tId))
            .thenAnswer((_) async => Right(testTVSeasonsDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchData(tId, tId)),
      expect: () => [
        DataLoading(),
        DataAvailable(testTVSeasonsDetail),
      ],
      verify: (bloc) {
        verify(mockGetTVSeasonsDetail.execute(tId, tId));
      },
    );

    blocTest<TVSeasonsDetailBloc, TVSeasonsDetailState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTVSeasonsDetail.execute(tId, tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchData(tId, tId)),
      expect: () => [
        DataLoading(),
        DataError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTVSeasonsDetail.execute(tId, tId));
      },
    );
  });
}
