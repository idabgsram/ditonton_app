part of 'home_popular_tv_bloc.dart';

abstract class HomePopularTVState extends Equatable {
  const HomePopularTVState();

  @override
  List<Object> get props => [];
}

class DataPopularTVEmpty extends HomePopularTVState {}

class DataPopularTVLoading extends HomePopularTVState {}

class DataPopularTVError extends HomePopularTVState {
  final String popularTVMessage;

  DataPopularTVError(this.popularTVMessage);

  @override
  List<Object> get props => [popularTVMessage];
}

class DataPopularTVAvailable extends HomePopularTVState {
  final List<TV> popularTVResult;

  DataPopularTVAvailable(this.popularTVResult);

  @override
  List<Object> get props => [popularTVResult];
}
