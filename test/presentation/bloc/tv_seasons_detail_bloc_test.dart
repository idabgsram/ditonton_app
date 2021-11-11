import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_seasons_detail.dart';
import 'package:ditonton/presentation/provider/tv_seasons_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_seasons_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVSeasonsDetail,
])
void main() {
  late TVSeasonsDetailNotifier provider;
  late MockGetTVSeasonsDetail mockGetTVSeasonsDetail;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVSeasonsDetail = MockGetTVSeasonsDetail();
    provider = TVSeasonsDetailNotifier(
      getTVSeasonsDetail: mockGetTVSeasonsDetail,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  void _arrangeUsecase() {
    when(mockGetTVSeasonsDetail.execute(tId, tId))
        .thenAnswer((_) async => Right(testTVSeasonsDetail));
  }

  group('Get TV Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVSeasonsDetail(tId, tId);
      // assert
      verify(mockGetTVSeasonsDetail.execute(tId, tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTVSeasonsDetail(tId, tId);
      // assert
      expect(provider.tvSeasonsState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVSeasonsDetail(tId, tId);
      // assert
      expect(provider.tvSeasonsState, RequestState.Loaded);
      expect(provider.tvSeasonsData, testTVSeasonsDetail);
      expect(listenerCallCount, 2);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVSeasonsDetail.execute(tId, tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTVSeasonsDetail(tId, tId);
      // assert
      expect(provider.tvSeasonsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
