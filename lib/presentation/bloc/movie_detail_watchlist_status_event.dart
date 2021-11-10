part of 'movie_detail_watchlist_status_bloc.dart';

abstract class MovieDetailWatchlistStatusEvent extends Equatable {
  const MovieDetailWatchlistStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistStatus extends MovieDetailWatchlistStatusEvent {
  final int id;
 
  LoadWatchlistStatus(this.id);
  @override
  List<Object> get props => [id];
}

class IsAddedToWatchlist extends MovieDetailWatchlistStatusEvent {}