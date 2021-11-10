part of 'movie_detail_recommendations_bloc.dart';

abstract class MovieDetailRecommendationsState extends Equatable {
  const MovieDetailRecommendationsState();

  @override
  List<Object> get props => [];
}

class DataRecommendationsEmpty extends MovieDetailRecommendationsState {}

class DataRecommendationsLoading extends MovieDetailRecommendationsState {}

class DataRecommendationsError extends MovieDetailRecommendationsState {
  final String movieRecommendationsMessage;

  DataRecommendationsError(this.movieRecommendationsMessage);

  @override
  List<Object> get props => [movieRecommendationsMessage];
}

class DataRecommendationsAvailable extends MovieDetailRecommendationsState {
  final List<Movie> movieRecommendations;

  DataRecommendationsAvailable(this.movieRecommendations);

  @override
  List<Object> get props => [movieRecommendations];
}
