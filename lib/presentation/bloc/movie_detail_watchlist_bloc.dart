import 'dart:async';

import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_watchlist_event.dart';
part 'movie_detail_watchlist_state.dart';

class MovieDetailWatchlistBloc
    extends Bloc<MovieDetailWatchlistEvent, MovieDetailWatchlistState> {
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;
  final GetWatchListStatus _getWatchlistStatus;
  MovieDetailWatchlistBloc(
      this._saveWatchlist, this._removeWatchlist, this._getWatchlistStatus)
      : super(StatusReceived(false, '')) {
    on<AddWatchlist>(_addWatchlist);
    on<RemoveFromWatchlist>(_removeFromWatchlist);
    on<LoadWatchlistStatus>(_onFetchEvent);
  }

  bool _isAddedtoWatchlist = false;
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';
  FutureOr<void> _addWatchlist(
      AddWatchlist event, Emitter<MovieDetailWatchlistState> emit) async {
    emit(StatusLoading());
    final result = await _saveWatchlist.execute(event.movie);

    result.fold(
      (failure) {
        emit(StatusError(failure.message));
      },
      (successMessage) {
        _isAddedtoWatchlist = true;
        emit(StatusReceived(true, successMessage));
      },
    );
  }

  FutureOr<void> _removeFromWatchlist(RemoveFromWatchlist event,
      Emitter<MovieDetailWatchlistState> emit) async {
    emit(StatusLoading());
    final result = await _removeWatchlist.execute(event.movie);

    result.fold(
      (failure) {
        emit(StatusError(failure.message));
      },
      (successMessage) {
        _isAddedtoWatchlist = false;
        emit(StatusReceived(false, successMessage));
      },
    );
  }

  FutureOr<void> _onFetchEvent(LoadWatchlistStatus event,
      Emitter<MovieDetailWatchlistState> emit) async {
    final statusResult = await _getWatchlistStatus.execute(event.id);
    _isAddedtoWatchlist = statusResult;
    emit(StatusReceived(_isAddedtoWatchlist, ''));
  }
}
