import 'dart:async';

import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'tv_detail_watchlist_event.dart';
part 'tv_detail_watchlist_state.dart';

class TVDetailWatchlistBloc
    extends Bloc<TVDetailWatchlistEvent, TVDetailWatchlistState> {
  final SaveTVWatchlist _saveWatchlist;
  final RemoveTVWatchlist _removeWatchlist;
  final GetTVWatchListStatus _getWatchlistStatus;
  TVDetailWatchlistBloc(
      this._saveWatchlist, this._removeWatchlist, this._getWatchlistStatus)
      : super(StatusReceived(false, '')) {
    on<AddWatchlist>(_addWatchlist);
    on<RemoveFromWatchlist>(_removeFromWatchlist);
    on<LoadWatchlistStatus>(_onFetchEvent);
  }

  bool _isAddedtoWatchlist = false;
  static const watchlistAddSuccessMessage = 'Added to TV Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from TV Watchlist';
  FutureOr<void> _addWatchlist(
      AddWatchlist event, Emitter<TVDetailWatchlistState> emit) async {
    final result = await _saveWatchlist.execute(event.movie);

    result.fold(
      (failure) {
        emit(StatusReceived(_isAddedtoWatchlist, failure.message));
      },
      (successMessage) {
        _isAddedtoWatchlist = true;
        emit(StatusReceived(true, successMessage));
      },
    );
  }

  FutureOr<void> _removeFromWatchlist(
      RemoveFromWatchlist event, Emitter<TVDetailWatchlistState> emit) async {
    final result = await _removeWatchlist.execute(event.movie);

    result.fold(
      (failure) {
        emit(StatusReceived(_isAddedtoWatchlist, failure.message));
      },
      (successMessage) {
        _isAddedtoWatchlist = false;
        emit(StatusReceived(false, successMessage));
      },
    );
  }

  FutureOr<void> _onFetchEvent(
      LoadWatchlistStatus event, Emitter<TVDetailWatchlistState> emit) async {
    final statusResult = await _getWatchlistStatus.execute(event.id);
    _isAddedtoWatchlist = statusResult;
    emit(StatusReceived(_isAddedtoWatchlist, ''));
  }
}
