import 'dart:async';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;
  TopRatedMoviesBloc(this._getTopRatedMovies) : super(DataEmpty()) {
    on<FetchData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      FetchData event, Emitter<TopRatedMoviesState> emit) async {
    emit(DataLoading());
    final result = await _getTopRatedMovies.execute();

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
