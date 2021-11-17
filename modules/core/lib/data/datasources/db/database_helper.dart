import 'dart:async';

import 'package:movies/data/models/movie_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tv_shows/data/models/tv_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  setDatabase(Database database) {
    _database = database;
  }

  static const String _tblWatchlist = 'watchlist';
  static const String _tblTVWatchlist = 'watchlist_tv';
  static const String _tblCache = 'cache';
  static const String _tblTVCache = 'cache_tv';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 2, onOpen: _onOpen);
    return db;
  }

  void _onOpen(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblTVWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
       CREATE TABLE IF NOT EXISTS $_tblCache (
         itemId INTEGER PRIMARY KEY,
         id INTEGER,
         title TEXT,
         overview TEXT,
         posterPath TEXT,
         category TEXT
       );
     ''');
    await db.execute('''
       CREATE TABLE IF NOT EXISTS $_tblTVCache (
         itemId INTEGER PRIMARY KEY,
         id INTEGER,
         name TEXT,
         overview TEXT,
         posterPath TEXT,
         category TEXT
       );
     ''');
  }

  Future<int> insertWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, movie.toJson());
  }

  Future<int> removeWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> insertTVWatchlist(TVTable tv) async {
    final db = await database;
    return await db!.insert(_tblTVWatchlist, tv.toJson());
  }

  Future<int> removeTVWatchlist(TVTable tv) async {
    final db = await database;
    return await db!.delete(
      _tblTVWatchlist,
      where: 'id = ?',
      whereArgs: [tv.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTVById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblTVWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

    return results;
  }

  Future<List<Map<String, dynamic>>> getWatchlistTV() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblTVWatchlist);

    return results;
  }

  Future<void> insertCacheTransaction(
      List<MovieTable> movies, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final movie in movies) {
        final movieJson = movie.toJson();
        movieJson['category'] = category;
        txn.insert(_tblCache, movieJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheMovies(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCache,
      where: 'category = ?',
      whereArgs: [category],
    );

    return results;
  }

  Future<int> clearCache(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCache,
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<void> insertTVCacheTransaction(
      List<TVTable> tvs, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final tv in tvs) {
        final tvJson = tv.toJson();
        tvJson['category'] = category;
        txn.insert(_tblTVCache, tvJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getTVCache(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblTVCache,
      where: 'category = ?',
      whereArgs: [category],
    );

    return results;
  }

  Future<int> clearTVCache(String category) async {
    final db = await database;
    return await db!.delete(
      _tblTVCache,
      where: 'category = ?',
      whereArgs: [category],
    );
  }
}
