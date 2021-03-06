part of 'movie_detail_watchlist_bloc.dart';

abstract class MovieDetailWatchlistEvent extends Equatable {
  const MovieDetailWatchlistEvent();
}

class AddWatchlist extends MovieDetailWatchlistEvent {
  final MovieDetail movie;
 
  AddWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}
class RemoveFromWatchlist extends MovieDetailWatchlistEvent {
  final MovieDetail movie;
 
  RemoveFromWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}

class LoadWatchlistStatus extends MovieDetailWatchlistEvent {
  final int id;
 
  LoadWatchlistStatus(this.id);
  @override
  List<Object> get props => [id];
}
