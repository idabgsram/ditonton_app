part of 'tv_detail_recommendations_bloc.dart';

abstract class TVDetailRecommendationsState extends Equatable {
  const TVDetailRecommendationsState();

  @override
  List<Object> get props => [];
}

class DataRecommendationsEmpty extends TVDetailRecommendationsState {}

class DataRecommendationsLoading extends TVDetailRecommendationsState {}

class DataRecommendationsError extends TVDetailRecommendationsState {
  final String tvRecommendationsMessage;

  DataRecommendationsError(this.tvRecommendationsMessage);

  @override
  List<Object> get props => [tvRecommendationsMessage];
}

class DataRecommendationsAvailable extends TVDetailRecommendationsState {
  final List<TV> tvRecommendations;

  DataRecommendationsAvailable(this.tvRecommendations);

  @override
  List<Object> get props => [tvRecommendations];
}
