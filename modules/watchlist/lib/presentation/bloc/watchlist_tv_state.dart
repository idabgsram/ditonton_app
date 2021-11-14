part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTVState extends Equatable {
  const WatchlistTVState();

  @override
  List<Object> get props => [];
}

class DataTVEmpty extends WatchlistTVState {}

class DataTVLoading extends WatchlistTVState {}

class DataTVError extends WatchlistTVState {
  final String tvMessage;

  DataTVError(this.tvMessage);

  @override
  List<Object> get props => [tvMessage];
}

class DataTVAvailable extends WatchlistTVState {
  final List<TV> tvResult;

  DataTVAvailable(this.tvResult);

  @override
  List<Object> get props => [tvResult];
}
