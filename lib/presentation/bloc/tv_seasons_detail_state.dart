part of 'tv_seasons_detail_bloc.dart';

abstract class TVSeasonsDetailState extends Equatable {
  const TVSeasonsDetailState();

  @override
  List<Object> get props => [];
}

class DataEmpty extends TVSeasonsDetailState {}

class DataLoading extends TVSeasonsDetailState {}

class DataError extends TVSeasonsDetailState {
  final String message;

  DataError(this.message);

  @override
  List<Object> get props => [message];
}

class DataAvailable extends TVSeasonsDetailState {
  final TVSeasons result;

  DataAvailable(this.result);

  @override
  List<Object> get props => [result];
}
