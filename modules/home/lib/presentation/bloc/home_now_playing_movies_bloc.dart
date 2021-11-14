import 'dart:async';

import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_now_playing_movies_event.dart';
part 'home_now_playing_movies_state.dart';

class HomeNowPlayingMoviesBloc
    extends Bloc<HomeNowPlayingMoviesEvent, HomeNowPlayingMoviesState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  HomeNowPlayingMoviesBloc(this._getNowPlayingMovies)
      : super(DataNowPlayingMoviesEmpty()) {
    on<FetchNowPlayingMoviesData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(FetchNowPlayingMoviesData event,
      Emitter<HomeNowPlayingMoviesState> emit) async {
    emit(DataNowPlayingMoviesLoading());
    final result = await _getNowPlayingMovies.execute();

    result.fold(
      (failure) {
        emit(DataNowPlayingMoviesError(failure.message));
      },
      (data) {
        emit(DataNowPlayingMoviesAvailable(data));
      },
    );
  }
}
