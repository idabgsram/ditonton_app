import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_episodes_detail.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_episodes_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_episodes_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVEpisodesDetail,
])
void main() {
  late TVEpisodesDetailNotifier provider;
  late MockGetTVEpisodesDetail mockGetTVEpisodesDetail;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVEpisodesDetail = MockGetTVEpisodesDetail();
    provider = TVEpisodesDetailNotifier(
      getTVEpisodesDetail: mockGetTVEpisodesDetail,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  void _arrangeUsecase() {
    when(mockGetTVEpisodesDetail.execute(tId,tId,tId))
        .thenAnswer((_) async => Right(testTVEpisodesDetail));
  }

  group('Get TV Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVEpisodesDetail(tId,tId,tId);
      // assert
      verify(mockGetTVEpisodesDetail.execute(tId,tId,tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTVEpisodesDetail(tId,tId,tId);
      // assert
      expect(provider.tvEpisodesState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVEpisodesDetail(tId,tId,tId);
      // assert
      expect(provider.tvEpisodesState, RequestState.Loaded);
      expect(provider.tvEpisodesData, testTVEpisodesDetail);
      expect(listenerCallCount, 2);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVEpisodesDetail.execute(tId,tId,tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTVEpisodesDetail(tId,tId,tId);
      // assert
      expect(provider.tvEpisodesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
