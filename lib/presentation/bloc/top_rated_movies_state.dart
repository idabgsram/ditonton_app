part of 'top_rated_movies_bloc.dart';

abstract class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();

  @override
  List<Object> get props => [];
}

class DataEmpty extends TopRatedMoviesState {}

class DataLoading extends TopRatedMoviesState {}

class DataError extends TopRatedMoviesState {
  final String message;

  DataError(this.message);

  @override
  List<Object> get props => [message];
}

class DataAvailable extends TopRatedMoviesState {
  final List<Movie> result;

  DataAvailable(this.result);

  @override
  List<Object> get props => [result];
}
