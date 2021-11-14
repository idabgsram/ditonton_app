import 'dart:async';

import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_popular_movies_event.dart';
part 'home_popular_movies_state.dart';

class HomePopularMoviesBloc
    extends Bloc<HomePopularMoviesEvent, HomePopularMoviesState> {
  final GetPopularMovies _getPopularMovies;
  HomePopularMoviesBloc(this._getPopularMovies)
      : super(DataPopularMoviesEmpty()) {
    on<FetchPopularMoviesData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(FetchPopularMoviesData event,
      Emitter<HomePopularMoviesState> emit) async {
    emit(DataPopularMoviesLoading());
    final result = await _getPopularMovies.execute();

    result.fold(
      (failure) {
        emit(DataPopularMoviesError(failure.message));
      },
      (data) {
        emit(DataPopularMoviesAvailable(data));
      },
    );
  }
}
