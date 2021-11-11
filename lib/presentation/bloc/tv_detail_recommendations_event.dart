part of 'tv_detail_recommendations_bloc.dart';

abstract class TVDetailRecommendationsEvent extends Equatable {
  const TVDetailRecommendationsEvent();

  @override
  List<Object> get props => [];
}

class FetchRecommendationsData extends TVDetailRecommendationsEvent {
  final int id;
 
  FetchRecommendationsData(this.id);
  @override
  List<Object> get props => [id];
}
