import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../dummy_data/dummy_objects.dart';

void main() {
  late DatabaseHelper dbSource;

  setUp(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    dbSource = DatabaseHelper();
  });

  group('Database initialization test', () {
    test('check database is initialized properly', () async {
      // arrange

      // act
      final result = await dbSource.database;
      // assert
      expect(result, isNotNull);
    });
  });

  group('Database function test', () {
    test('check TV-related function is working', () async {
      // arrange
      dbSource.setDatabase(await openDatabase(inMemoryDatabasePath, version: 2,
          onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE watchlist_tv (id INTEGER PRIMARY KEY, name TEXT, overview TEXT, posterPath TEXT)');
      }));
      // act
      final testInsert = await dbSource.insertTVWatchlist(testTVTable);
      final testGetByID = await dbSource.getTVById(1);
      final testGet = await dbSource.getWatchlistTV();
      final testRemove = await dbSource.removeTVWatchlist(testTVTable);
      await deleteDatabase(inMemoryDatabasePath);
      // assert
      expect(testInsert, 1);
      expect(testGetByID, testTVTable.toJson());
      expect(testGet, [
        {
          'id': 1,
          'name': 'name',
          'overview': 'overview',
          'posterPath': 'posterPath'
        }
      ]);
      expect(testRemove, 1);
    });

    test('check Movies-related function is working', () async {
      // arrange
      dbSource.setDatabase(await openDatabase(inMemoryDatabasePath, version: 2,
          onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE watchlist (id INTEGER PRIMARY KEY, title TEXT, overview TEXT, posterPath TEXT)');
      }));
      // act
      final testInsert = await dbSource.insertWatchlist(testMovieTable);
      final testGetByID = await dbSource.getMovieById(1);
      final testGet = await dbSource.getWatchlistMovies();
      final testRemove = await dbSource.removeWatchlist(testMovieTable);
      await deleteDatabase(inMemoryDatabasePath);
      // assert
      expect(testInsert, 1);
      expect(testGetByID, testMovieTable.toJson());
      expect(testGet, [
        {
          'id': 1,
          'title': 'title',
          'overview': 'overview',
          'posterPath': 'posterPath'
        }
      ]);
      expect(testRemove, 1);
    });
  });
}
