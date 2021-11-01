import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_now_playing_movies_event.dart';
part 'home_now_playing_movies_state.dart';

class HomeNowPlayingMoviesBloc
    extends Bloc<HomeNowPlayingMoviesEvent, HomeNowPlayingMoviesState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  HomeNowPlayingMoviesBloc(this._getNowPlayingMovies)
      : super(DataNowPlayingMoviesEmpty());

  @override
  Stream<HomeNowPlayingMoviesState> mapEventToState(
    HomeNowPlayingMoviesEvent event,
  ) async* {
    if (event is FetchNowPlayingMoviesData) {
      yield DataNowPlayingMoviesLoading();
      final result = await _getNowPlayingMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield DataNowPlayingMoviesError(failure.message);
        },
        (data) async* {
          yield DataNowPlayingMoviesAvailable(data);
        },
      );
    }
  }
}
