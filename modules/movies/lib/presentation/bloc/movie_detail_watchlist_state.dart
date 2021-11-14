part of 'movie_detail_watchlist_bloc.dart';

abstract class MovieDetailWatchlistState extends Equatable {
  const MovieDetailWatchlistState();

  @override
  List<Object> get props => [];
}

class StatusLoading extends MovieDetailWatchlistState {}
class StatusError extends MovieDetailWatchlistState {
  final String message;

  StatusError(this.message);

  @override
  List<Object> get props => [message];
}
class StatusReceived extends MovieDetailWatchlistState {
  final bool status;
  final String message;

  StatusReceived(this.status, this.message);

  @override
  List<Object> get props => [status, message];
}
