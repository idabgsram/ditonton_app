import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:flutter/foundation.dart';

class WatchlistNotifier extends ChangeNotifier {
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistTVs = <TV>[];
  List<TV> get watchlistTVs => _watchlistTVs;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistNotifier(
      {required this.getWatchlistMovies, required this.getWatchlistTVs});

  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchlistTV getWatchlistTVs;

  Future<void> fetchWatchlist() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistMovies = moviesData;
        notifyListeners();
      },
    );

    final resultTV = await getWatchlistTVs.execute();
    resultTV.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _watchlistState = RequestState.Loaded;
        _watchlistTVs = tvsData;
        notifyListeners();
      },
    );
  }
}
