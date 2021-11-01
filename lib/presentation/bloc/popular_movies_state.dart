part of 'popular_movies_bloc.dart';

abstract class PopularMoviesState extends Equatable {
  const PopularMoviesState();

  @override
  List<Object> get props => [];
}

class DataEmpty extends PopularMoviesState {}

class DataLoading extends PopularMoviesState {}

class DataError extends PopularMoviesState {
  final String message;

  DataError(this.message);

  @override
  List<Object> get props => [message];
}

class DataAvailable extends PopularMoviesState {
  final List<Movie> result;

  DataAvailable(this.result);

  @override
  List<Object> get props => [result];
}
