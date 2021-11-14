import 'dart:async';

import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_top_rated_movies_event.dart';
part 'home_top_rated_movies_state.dart';

class HomeTopRatedMoviesBloc
    extends Bloc<HomeTopRatedMoviesEvent, HomeTopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;
  HomeTopRatedMoviesBloc(this._getTopRatedMovies)
      : super(DataTopRatedMoviesEmpty()) {
    on<FetchTopRatedMoviesData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(FetchTopRatedMoviesData event,
      Emitter<HomeTopRatedMoviesState> emit) async {
    emit(DataTopRatedMoviesLoading());
    final result = await _getTopRatedMovies.execute();

    result.fold(
      (failure) {
        emit(DataTopRatedMoviesError(failure.message));
      },
      (data) {
        emit(DataTopRatedMoviesAvailable(data));
      },
    );
  }
}
