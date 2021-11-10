import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_watchlist_status_event.dart';

class MovieDetailWatchlistStatusBloc
    extends Bloc<MovieDetailWatchlistStatusEvent, bool> {
  final GetWatchListStatus _getWatchlistStatus;
  MovieDetailWatchlistStatusBloc(
      this._getWatchlistStatus)
      : super(false);
  bool _isAddedtoWatchlist = false;
  @override
  Stream<bool> mapEventToState(
    MovieDetailWatchlistStatusEvent event,
  ) async* {
    if (event is LoadWatchlistStatus) {
      final statusResult = await _getWatchlistStatus.execute(event.id);
      _isAddedtoWatchlist = statusResult;
    }
    yield _isAddedtoWatchlist;
  }
}
