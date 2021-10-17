import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TVDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to TV Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from TV Watchlist';

  final GetTVDetail getTVDetail;
  final GetTVRecommendations getTVRecommendations;
  final GetTVWatchListStatus getTVWatchListStatus;
  final SaveTVWatchlist saveTVWatchlist;
  final RemoveTVWatchlist removeTVWatchlist;

  TVDetailNotifier({
    required this.getTVDetail,
    required this.getTVRecommendations,
    required this.getTVWatchListStatus,
    required this.saveTVWatchlist,
    required this.removeTVWatchlist,
  });

  late TVDetail _tv;
  TVDetail get tvData => _tv;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  List<TV> _tvRecommendations = [];
  List<TV> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTVDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTVDetail.execute(id);
    final recommendationResult = await getTVRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _recommendationState = RequestState.Loading;
        _tv = tv;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvs) {
            _recommendationState = RequestState.Loaded;
            _tvRecommendations = tvs;
          },
        );
        _tvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _tvWatchlistMessage = '';
  String get tvWatchlistMessage => _tvWatchlistMessage;

  Future<void> addTVWatchlist(TVDetail tv) async {
    final result = await saveTVWatchlist.execute(tv);

    await result.fold(
      (failure) async {
        _tvWatchlistMessage = failure.message;
      },
      (successMessage) async {
        _tvWatchlistMessage = successMessage;
      },
    );

    await loadTVWatchlistStatus(tv.id);
  }

  Future<void> removeFromTVWatchlist(TVDetail tv) async {
    final result = await removeTVWatchlist.execute(tv);

    await result.fold(
      (failure) async {
        _tvWatchlistMessage = failure.message;
      },
      (successMessage) async {
        _tvWatchlistMessage = successMessage;
      },
    );

    await loadTVWatchlistStatus(tv.id);
  }

  Future<void> loadTVWatchlistStatus(int id) async {
    final result = await getTVWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
