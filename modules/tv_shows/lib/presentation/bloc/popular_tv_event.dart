part of 'popular_tv_bloc.dart';

abstract class PopularTVEvent extends Equatable {
  const PopularTVEvent();
}

class FetchData extends PopularTVEvent {
  @override
  List<Object> get props => [];
}
