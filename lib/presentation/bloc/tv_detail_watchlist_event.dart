part of 'tv_detail_watchlist_bloc.dart';

abstract class TVDetailWatchlistEvent extends Equatable {
  const TVDetailWatchlistEvent();
}

class AddWatchlist extends TVDetailWatchlistEvent {
  final TVDetail tv;
 
  AddWatchlist(this.tv);
  @override
  List<Object> get props => [tv];
}
class RemoveFromWatchlist extends TVDetailWatchlistEvent {
  final TVDetail tv;
 
  RemoveFromWatchlist(this.tv);
  @override
  List<Object> get props => [tv];
}

class LoadWatchlistStatus extends TVDetailWatchlistEvent {
  final int id;
 
  LoadWatchlistStatus(this.id);
  @override
  List<Object> get props => [id];
}
