import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;
  WatchlistMoviesBloc(this._getWatchlistMovies) : super(DataEmpty());

  @override
  Stream<WatchlistMoviesState> mapEventToState(
    WatchlistMoviesEvent event,
  ) async* {
    if (event is GetWatchlistMoviesData) {
      yield DataLoading();
      final result = await _getWatchlistMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield DataError(failure.message);
        },
        (data) async* {
          yield DataAvailable(data);
        },
      );
    }
  }
}
