part of 'home_now_playing_movies_bloc.dart';

abstract class HomeNowPlayingMoviesEvent extends Equatable {
  const HomeNowPlayingMoviesEvent();
}

class FetchNowPlayingMoviesData extends HomeNowPlayingMoviesEvent {
  @override
  List<Object> get props => [];
}
