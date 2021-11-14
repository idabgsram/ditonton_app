part of 'top_rated_tv_bloc.dart';

abstract class TopRatedTVState extends Equatable {
  const TopRatedTVState();

  @override
  List<Object> get props => [];
}

class DataEmpty extends TopRatedTVState {}

class DataLoading extends TopRatedTVState {}

class DataError extends TopRatedTVState {
  final String message;

  DataError(this.message);

  @override
  List<Object> get props => [message];
}

class DataAvailable extends TopRatedTVState {
  final List<TV> result;

  DataAvailable(this.result);

  @override
  List<Object> get props => [result];
}
