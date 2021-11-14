import 'dart:async';

import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies _getPopularMovies;
  PopularMoviesBloc(this._getPopularMovies) : super(DataEmpty()) {
    on<FetchData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      FetchData event, Emitter<PopularMoviesState> emit) async {
    emit(DataLoading());
    final result = await _getPopularMovies.execute();

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
