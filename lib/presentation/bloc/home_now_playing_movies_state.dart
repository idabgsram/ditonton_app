part of 'home_now_playing_movies_bloc.dart';

abstract class HomeNowPlayingMoviesState extends Equatable {
  const HomeNowPlayingMoviesState();

  @override
  List<Object> get props => [];
}

class DataNowPlayingMoviesEmpty extends HomeNowPlayingMoviesState {}

class DataNowPlayingMoviesLoading extends HomeNowPlayingMoviesState {}

class DataNowPlayingMoviesError extends HomeNowPlayingMoviesState {
  final String nowPlayingMoviesMessage;

  DataNowPlayingMoviesError(this.nowPlayingMoviesMessage);

  @override
  List<Object> get props => [nowPlayingMoviesMessage];
}

class DataNowPlayingMoviesAvailable extends HomeNowPlayingMoviesState {
  final List<Movie> nowPlayingMoviesResult;

  DataNowPlayingMoviesAvailable(this.nowPlayingMoviesResult);

  @override
  List<Object> get props => [nowPlayingMoviesResult];
}
