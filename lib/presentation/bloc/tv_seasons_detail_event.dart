part of 'tv_seasons_detail_bloc.dart';

abstract class TVSeasonsDetailEvent extends Equatable {
  const TVSeasonsDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchData extends TVSeasonsDetailEvent {
  
  final int id, seasonNumber;
 
  FetchData(this.id, this.seasonNumber);
  @override
  List<Object> get props => [id,seasonNumber];
}
