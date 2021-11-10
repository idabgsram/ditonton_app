import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_watchlist_event.dart';

class MovieDetailWatchlistBloc
    extends Bloc<MovieDetailWatchlistEvent, String> {
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;
  MovieDetailWatchlistBloc( this._saveWatchlist, this._removeWatchlist)
      : super('');
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  @override
  Stream<String> mapEventToState(
    MovieDetailWatchlistEvent event,
  ) async* {
    if (event is AddWatchlist) {
      final result = await _saveWatchlist.execute(event.movie);

      yield* result.fold(
        (failure) async* {
          yield failure.message;
        },
        (successMessage) async* {
          yield successMessage;
        },
      );
    }
    if (event is RemoveFromWatchlist) {
      final result = await _removeWatchlist.execute(event.movie);

      yield* result.fold(
        (failure) async* {
          yield failure.message;
        },
        (successMessage) async* {
          yield successMessage;
        },
      );
    }
    
  }
}
