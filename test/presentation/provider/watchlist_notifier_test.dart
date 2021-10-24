import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies,GetWatchlistTV])
void main() {
  late WatchlistNotifier provider;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchlistTV mockGetWatchlistTVs;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchlistTVs = MockGetWatchlistTV();
    provider = WatchlistNotifier(
      getWatchlistMovies: mockGetWatchlistMovies,
      getWatchlistTVs: mockGetWatchlistTVs,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change data when data is gotten successfully', () async {
    // arrange
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => Right([testWatchlistMovie]));
    when(mockGetWatchlistTVs.execute())
        .thenAnswer((_) async => Right([testWatchlistTV]));
    // act
    await provider.fetchWatchlist();
    // assert
    expect(provider.watchlistState, RequestState.Loaded);
    expect(provider.watchlistMovies, [testWatchlistMovie]);
    expect(provider.watchlistTVs, [testWatchlistTV]);
    expect(listenerCallCount, 3);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    when(mockGetWatchlistTVs.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlist();
    // assert
    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 3);
  });
}
