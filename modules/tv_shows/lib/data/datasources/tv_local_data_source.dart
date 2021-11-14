import 'package:core/core.dart';
import 'package:tv_shows/data/models/tv_table.dart';

abstract class TVLocalDataSource {
  Future<String> insertTVWatchlist(TVTable tv);
  Future<String> removeTVWatchlist(TVTable tv);
  Future<TVTable?> getTVById(int id);
  Future<List<TVTable>> getWatchlistTVs();
  Future<void> cacheTVs(List<TVTable> tvs,String categories);
  Future<List<TVTable>> getCachedTVs(String categories);
}

class TVLocalDataSourceImpl implements TVLocalDataSource {
  final DatabaseHelper databaseHelper;

  TVLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertTVWatchlist(TVTable tv) async {
    try {
      await databaseHelper.insertTVWatchlist(tv);
      return 'Added to TV Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeTVWatchlist(TVTable tv) async {
    try {
      await databaseHelper.removeTVWatchlist(tv);
      return 'Removed from TV Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVTable?> getTVById(int id) async {
    final result = await databaseHelper.getTVById(id);
    if (result != null) {
      return TVTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVTable>> getWatchlistTVs() async {
    final result = await databaseHelper.getWatchlistTV();
    return result.map((data) => TVTable.fromMap(data)).toList();
  }


  @override
  Future<void> cacheTVs(List<TVTable> tvs, String categories) async {
    await databaseHelper.clearTVCache(categories);
    await databaseHelper.insertTVCacheTransaction(tvs, categories);
  }

  @override
  Future<List<TVTable>> getCachedTVs(String categories) async {
    final result = await databaseHelper.getTVCache(categories);
    if (result.length > 0) {
      return result.map((data) => TVTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }
}
