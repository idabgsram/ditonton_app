part of 'home_top_rated_tv_bloc.dart';

abstract class HomeTopRatedTVState extends Equatable {
  const HomeTopRatedTVState();

  @override
  List<Object> get props => [];
}

class DataTopRatedTVEmpty extends HomeTopRatedTVState {}

class DataTopRatedTVLoading extends HomeTopRatedTVState {}

class DataTopRatedTVError extends HomeTopRatedTVState {
  final String topRatedTVMessage;

  DataTopRatedTVError(this.topRatedTVMessage);

  @override
  List<Object> get props => [topRatedTVMessage];
}

class DataTopRatedTVAvailable extends HomeTopRatedTVState {
  final List<TV> topRatedTVResult;

  DataTopRatedTVAvailable(this.topRatedTVResult);

  @override
  List<Object> get props => [topRatedTVResult];
}
