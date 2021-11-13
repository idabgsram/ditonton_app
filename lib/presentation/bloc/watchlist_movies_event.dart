part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesEvent extends Equatable {
  const WatchlistMoviesEvent();
}

class GetWatchlistMoviesData extends WatchlistMoviesEvent {
  @override
  List<Object> get props => [];
}
