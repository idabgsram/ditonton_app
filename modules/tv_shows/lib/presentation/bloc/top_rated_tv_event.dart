part of 'top_rated_tv_bloc.dart';

abstract class TopRatedTVEvent extends Equatable {
  const TopRatedTVEvent();
}

class FetchData extends TopRatedTVEvent {
  @override
  List<Object> get props => [];
}
