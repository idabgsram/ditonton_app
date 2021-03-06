import 'package:core/core.dart';
import 'package:tv_shows/data/datasources/tv_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TVLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save tv watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertTVWatchlist(testTVTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertTVWatchlist(testTVTable);
      // assert
      expect(result, 'Added to TV Watchlist');
    });

    test('should throw tv DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertTVWatchlist(testTVTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertTVWatchlist(testTVTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove tv watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeTVWatchlist(testTVTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeTVWatchlist(testTVTable);
      // assert
      expect(result, 'Removed from TV Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeTVWatchlist(testTVTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeTVWatchlist(testTVTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get TV Detail By Id', () {
    final tId = 1;

    test('should return TV Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTVById(tId))
          .thenAnswer((_) async => testTVMap);
      // act
      final result = await dataSource.getTVById(tId);
      // assert
      expect(result, testTVTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTVById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTVById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist TVs', () {
    test('should return list of TVTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTV())
          .thenAnswer((_) async => [testTVMap]);
      // act
      final result = await dataSource.getWatchlistTVs();
      // assert
      expect(result, [testTVTable]);
    });
  });

  group('cache tvs section', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearTVCache('ota'))
          .thenAnswer((_) async => 1);
      // act
      await dataSource.cacheTVs([testTVCache],'ota');
      // assert
      verify(mockDatabaseHelper.clearTVCache('ota'));
      verify(mockDatabaseHelper
          .insertTVCacheTransaction([testTVCache], 'ota'));
    });

    test('should return list of tvs from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getTVCache('ota'))
          .thenAnswer((_) async => [testTVCacheMap]);
      // act
      final result = await dataSource.getCachedTVs('ota');
      // assert
      expect(result, [testTVCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      // arrange
      when(mockDatabaseHelper.getTVCache('ota'))
          .thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedTVs('ota');
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });
}
