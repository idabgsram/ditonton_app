part of 'movie_detail_recommendations_bloc.dart';

abstract class MovieDetailRecommendationsEvent extends Equatable {
  const MovieDetailRecommendationsEvent();
}

class FetchRecommendationsData extends MovieDetailRecommendationsEvent {
  final int id;
 
  FetchRecommendationsData(this.id);
  @override
  List<Object> get props => [id];
}
