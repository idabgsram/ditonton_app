part of 'home_top_rated_movies_bloc.dart';

abstract class HomeTopRatedMoviesEvent extends Equatable {
  const HomeTopRatedMoviesEvent();
}

class FetchTopRatedMoviesData extends HomeTopRatedMoviesEvent {
  @override
  List<Object> get props => [];
}
