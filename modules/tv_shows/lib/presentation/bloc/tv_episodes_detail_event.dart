part of 'tv_episodes_detail_bloc.dart';

abstract class TVEpisodesDetailEvent extends Equatable {
  const TVEpisodesDetailEvent();
}

class FetchData extends TVEpisodesDetailEvent {
  
  final int id, seasonNumber, epsNumber;
 
  FetchData(this.id, this.seasonNumber, this.epsNumber);
  @override
  List<Object> get props => [id,seasonNumber,epsNumber];
}
