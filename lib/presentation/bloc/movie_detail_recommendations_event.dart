part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchDetailData extends MovieDetailEvent {
  final int id;
 
  FetchDetailData(this.id);
  @override
  List<Object> get props => [id];
}
