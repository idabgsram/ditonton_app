part of 'popular_movies_bloc.dart';

abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchData extends PopularMoviesEvent {
  @override
  List<Object> get props => [];
}
