import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_episodes_detail.dart';
import 'package:ditonton/presentation/bloc/tv_episodes_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_episodes_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVEpisodesDetail,
])
void main() {
  late TVEpisodesDetailBloc bloc;
  late MockGetTVEpisodesDetail mockGetTVEpisodesDetail;

  setUp(() {
    mockGetTVEpisodesDetail = MockGetTVEpisodesDetail();
    bloc = TVEpisodesDetailBloc(mockGetTVEpisodesDetail);
  });

  final tId = 1;

  group('Get TV Detail', () {
    test('initial state should be empty', () {
      expect(bloc.state, DataEmpty());
      expect(FetchData(tId, tId, tId).props, [tId, tId, tId]);
    });

    blocTest<TVEpisodesDetailBloc, TVEpisodesDetailState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTVEpisodesDetail.execute(tId, tId, tId))
            .thenAnswer((_) async => Right(testTVEpisodesDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchData(tId, tId, tId)),
      expect: () => [
        DataLoading(),
        DataAvailable(testTVEpisodesDetail),
      ],
      verify: (bloc) {
        verify(mockGetTVEpisodesDetail.execute(tId, tId, tId));
      },
    );

    blocTest<TVEpisodesDetailBloc, TVEpisodesDetailState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTVEpisodesDetail.execute(tId, tId, tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchData(tId, tId, tId)),
      expect: () => [
        DataLoading(),
        DataError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTVEpisodesDetail.execute(tId, tId, tId));
      },
    );
  });
}
