part of 'popular_tv_bloc.dart';

abstract class PopularTVState extends Equatable {
  const PopularTVState();

  @override
  List<Object> get props => [];
}

class DataEmpty extends PopularTVState {}

class DataLoading extends PopularTVState {}

class DataError extends PopularTVState {
  final String message;

  DataError(this.message);

  @override
  List<Object> get props => [message];
}

class DataAvailable extends PopularTVState {
  final List<TV> result;

  DataAvailable(this.result);

  @override
  List<Object> get props => [result];
}
