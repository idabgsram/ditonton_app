part of 'home_popular_movies_bloc.dart';

abstract class HomePopularMoviesState extends Equatable {
  const HomePopularMoviesState();

  @override
  List<Object> get props => [];
}

class DataPopularMoviesEmpty extends HomePopularMoviesState {}

class DataPopularMoviesLoading extends HomePopularMoviesState {}

class DataPopularMoviesError extends HomePopularMoviesState {
  final String popularMoviesMessage;

  DataPopularMoviesError(this.popularMoviesMessage);

  @override
  List<Object> get props => [popularMoviesMessage];
}

class DataPopularMoviesAvailable extends HomePopularMoviesState {
  final List<Movie> popularMoviesResult;

  DataPopularMoviesAvailable(this.popularMoviesResult);

  @override
  List<Object> get props => [popularMoviesResult];
}
