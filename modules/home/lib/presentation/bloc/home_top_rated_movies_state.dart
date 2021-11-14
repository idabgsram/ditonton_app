part of 'home_top_rated_movies_bloc.dart';

abstract class HomeTopRatedMoviesState extends Equatable {
  const HomeTopRatedMoviesState();

  @override
  List<Object> get props => [];
}

class DataTopRatedMoviesEmpty extends HomeTopRatedMoviesState {}

class DataTopRatedMoviesLoading extends HomeTopRatedMoviesState {}

class DataTopRatedMoviesError extends HomeTopRatedMoviesState {
  final String topRatedMoviesMessage;

  DataTopRatedMoviesError(this.topRatedMoviesMessage);

  @override
  List<Object> get props => [topRatedMoviesMessage];
}

class DataTopRatedMoviesAvailable extends HomeTopRatedMoviesState {
  final List<Movie> topRatedMoviesResult;

  DataTopRatedMoviesAvailable(this.topRatedMoviesResult);

  @override
  List<Object> get props => [topRatedMoviesResult];
}
