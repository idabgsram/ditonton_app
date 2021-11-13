import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:ditonton/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetTVWatchListStatus,
  SaveTVWatchlist,
  RemoveTVWatchlist,
])
void main() {
  late TVDetailBloc bloc;
  late TVDetailRecommendationsBloc recommendationsBloc;
  late TVDetailWatchlistBloc watchlistBloc;
  late MockGetTVDetail mockGetTVDetail;
  late MockGetTVRecommendations mockGetTVRecommendations;
  late MockGetTVWatchListStatus mockGetWatchlistStatus;
  late MockSaveTVWatchlist mockSaveWatchlist;
  late MockRemoveTVWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetTVDetail = MockGetTVDetail();
    mockGetTVRecommendations = MockGetTVRecommendations();
    mockGetWatchlistStatus = MockGetTVWatchListStatus();
    mockSaveWatchlist = MockSaveTVWatchlist();
    mockRemoveWatchlist = MockRemoveTVWatchlist();
    bloc = TVDetailBloc(mockGetTVDetail);
    recommendationsBloc = TVDetailRecommendationsBloc(mockGetTVRecommendations);
    watchlistBloc = TVDetailWatchlistBloc(
        mockSaveWatchlist, mockRemoveWatchlist, mockGetWatchlistStatus);
  });

  final tId = 1;

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
  final tTVs = <TV>[tTV];

  group('Get TV Detail', () {
    test('initial state should be empty', () {
      expect(bloc.state, DataEmpty());
      expect(FetchDetailData(tId).props, [tId]);
    });

    blocTest<TVDetailBloc, TVDetailState>(
      'Should emit [Loading, Available] when data is gotten successfully',
      build: () {
        when(mockGetTVDetail.execute(tId))
            .thenAnswer((_) async => Right(testTVDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchDetailData(tId)),
      expect: () => [
        DataLoading(),
        DataAvailable(testTVDetail),
      ],
      verify: (bloc) {
        verify(mockGetTVDetail.execute(tId));
      },
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTVDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchDetailData(tId)),
      expect: () => [
        DataLoading(),
        DataError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTVDetail.execute(tId));
      },
    );
  });

  group('Get TV Recommendations', () {
    test('initial state should be empty', () {
      expect(recommendationsBloc.state, DataRecommendationsEmpty());
      expect(FetchRecommendationsData(tId).props, [tId]);
    });

    blocTest<TVDetailRecommendationsBloc, TVDetailRecommendationsState>(
      'Should emit [Loading, Available] when data is gotten successfully',
      build: () {
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTVs));
        return recommendationsBloc;
      },
      act: (bloc) => bloc.add(FetchRecommendationsData(tId)),
      expect: () => [
        DataRecommendationsLoading(),
        DataRecommendationsAvailable(tTVs),
      ],
      verify: (bloc) {
        verify(mockGetTVRecommendations.execute(tId));
      },
    );

    blocTest<TVDetailRecommendationsBloc, TVDetailRecommendationsState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return recommendationsBloc;
      },
      act: (bloc) => bloc.add(FetchRecommendationsData(tId)),
      expect: () => [
        DataRecommendationsLoading(),
        DataRecommendationsError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTVRecommendations.execute(tId));
      },
    );
  });

  group('Watchlist', () {
    test('initial state should be empty', () {
      expect(watchlistBloc.state, StatusReceived(false, ''));
      expect(AddWatchlist(testTVDetail).props, [testTVDetail]);
      expect(RemoveFromWatchlist(testTVDetail).props, [testTVDetail]);
      expect(LoadWatchlistStatus(tId).props, [tId]);
    });

    blocTest<TVDetailWatchlistBloc, TVDetailWatchlistState>(
      'Should emit [Received] when data is saved successfully',
      build: () {
        when(mockSaveWatchlist.execute(testTVDetail)).thenAnswer((_) async =>
            Right(TVDetailWatchlistBloc.watchlistAddSuccessMessage));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(testTVDetail)),
      expect: () => [
        StatusLoading(),
        StatusReceived(true, TVDetailWatchlistBloc.watchlistAddSuccessMessage),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testTVDetail));
      },
    );

    blocTest<TVDetailWatchlistBloc, TVDetailWatchlistState>(
      'Should emit [Error] when save data is unsuccessful',
      build: () {
        when(mockSaveWatchlist.execute(testTVDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(testTVDetail)),
      expect: () => [
        StatusLoading(),
        StatusError('Database Failure'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testTVDetail));
      },
    );

    blocTest<TVDetailWatchlistBloc, TVDetailWatchlistState>(
      'Should emit [Received] when data is removed successfully',
      build: () {
        when(mockRemoveWatchlist.execute(testTVDetail)).thenAnswer((_) async =>
            Right(TVDetailWatchlistBloc.watchlistRemoveSuccessMessage));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testTVDetail)),
      expect: () => [
        StatusLoading(),
        StatusReceived(
            false, TVDetailWatchlistBloc.watchlistRemoveSuccessMessage),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testTVDetail));
      },
    );

    blocTest<TVDetailWatchlistBloc, TVDetailWatchlistState>(
      'Should emit [Error] when remove data is unsuccessful',
      build: () {
        when(mockRemoveWatchlist.execute(testTVDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testTVDetail)),
      expect: () => [
        StatusLoading(),
        StatusError('Database Failure'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testTVDetail));
      },
    );
    blocTest<TVDetailWatchlistBloc, TVDetailWatchlistState>(
      'Should emit [Received] when get status',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(tId)),
      expect: () => [
        StatusReceived(true, ''),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });
}
