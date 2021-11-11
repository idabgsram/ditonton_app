import 'dart:async';

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTVBloc extends Bloc<WatchlistTVEvent, WatchlistTVState> {
  final GetWatchlistTV _getWatchlistTV;
  WatchlistTVBloc(this._getWatchlistTV) : super(DataTVEmpty()) {
    on<GetWatchlistTVData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      GetWatchlistTVData event, Emitter<WatchlistTVState> emit) async {
    emit(DataTVLoading());
    final result = await _getWatchlistTV.execute();

    result.fold(
      (failure) {
        emit(DataTVError(failure.message));
      },
      (data) {
        emit(DataTVAvailable(data));
      },
    );
  }
}
