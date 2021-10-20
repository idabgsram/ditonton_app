import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/tv_table.dart';

abstract class TVLocalDataSource {
  Future<String> insertTVWatchlist(TVTable tv);
  Future<String> removeTVWatchlist(TVTable tv);
  Future<TVTable?> getTVById(int id);
  Future<List<TVTable>> getWatchlistTVs();
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
}
