part of 'tv_detail_watchlist_bloc.dart';

abstract class TVDetailWatchlistEvent extends Equatable {
  const TVDetailWatchlistEvent();
}

class AddWatchlist extends TVDetailWatchlistEvent {
  final TVDetail movie;
 
  AddWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}
class RemoveFromWatchlist extends TVDetailWatchlistEvent {
  final TVDetail movie;
 
  RemoveFromWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}

class LoadWatchlistStatus extends TVDetailWatchlistEvent {
  final int id;
 
  LoadWatchlistStatus(this.id);
  @override
  List<Object> get props => [id];
}
