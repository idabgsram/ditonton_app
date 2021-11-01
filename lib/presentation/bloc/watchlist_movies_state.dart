part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();

  @override
  List<Object> get props => [];
}

class DataEmpty extends WatchlistMoviesState {}

class DataLoading extends WatchlistMoviesState {}

class DataError extends WatchlistMoviesState {
  final String message;

  DataError(this.message);

  @override
  List<Object> get props => [message];
}

class DataAvailable extends WatchlistMoviesState {
  final List<Movie> result;

  DataAvailable(this.result);

  @override
  List<Object> get props => [result];
}
