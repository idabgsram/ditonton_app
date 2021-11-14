part of 'tv_detail_watchlist_bloc.dart';

abstract class TVDetailWatchlistState extends Equatable {
  const TVDetailWatchlistState();

  @override
  List<Object> get props => [];
}

class StatusLoading extends TVDetailWatchlistState {}
class StatusError extends TVDetailWatchlistState {
  final String message;

  StatusError(this.message);

  @override
  List<Object> get props => [message];
}
class StatusReceived extends TVDetailWatchlistState {
  final bool status;
  final String message;

  StatusReceived(this.status, this.message);

  @override
  List<Object> get props => [status, message];
}
