part of 'home_popular_movies_bloc.dart';

abstract class HomePopularMoviesEvent extends Equatable {
  const HomePopularMoviesEvent();
}

class FetchPopularMoviesData extends HomePopularMoviesEvent {
  @override
  List<Object> get props => [];
}
