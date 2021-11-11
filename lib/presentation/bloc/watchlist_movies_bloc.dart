import 'dart:async';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;
  WatchlistMoviesBloc(this._getWatchlistMovies) : super(DataEmpty()) {
    on<GetWatchlistMoviesData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      GetWatchlistMoviesData event, Emitter<WatchlistMoviesState> emit) async {
    emit(DataLoading());
    final result = await _getWatchlistMovies.execute();

    result.fold(
      (failure) {
        emit(DataError(failure.message));
      },
      (data) {
        emit(DataAvailable(data));
      },
    );
  }
}
