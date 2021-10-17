import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:flutter/foundation.dart';

class WatchlistTVNotifier extends ChangeNotifier {
  var _watchlistTVs = <TV>[];
  List<TV> get watchlistTVs => _watchlistTVs;

  var _tvWatchlistState = RequestState.Empty;
  RequestState get watchlistState => _tvWatchlistState;

  String _message = '';
  String get message => _message;

  WatchlistTVNotifier({required this.getWatchlistTVs});

  final GetWatchlistTV getWatchlistTVs;

  Future<void> fetchWatchlistTVs() async {
    _tvWatchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTVs.execute();
    result.fold(
      (failure) {
        _tvWatchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _tvWatchlistState = RequestState.Loaded;
        _watchlistTVs = tvsData;
        notifyListeners();
      },
    );
  }
}
