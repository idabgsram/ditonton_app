part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class DataEmpty extends MovieDetailState {}

class DataLoading extends MovieDetailState {}

class DataError extends MovieDetailState {
  final String message;

  DataError(this.message);

  @override
  List<Object> get props => [message];
}

class DataAvailable extends MovieDetailState {
  final MovieDetail result;

  DataAvailable(this.result);

  @override
  List<Object> get props => [result];
}
