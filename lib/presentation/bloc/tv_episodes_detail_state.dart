part of 'tv_episodes_detail_bloc.dart';

abstract class TVEpisodesDetailState extends Equatable {
  const TVEpisodesDetailState();

  @override
  List<Object> get props => [];
}

class DataEmpty extends TVEpisodesDetailState {}

class DataLoading extends TVEpisodesDetailState {}

class DataError extends TVEpisodesDetailState {
  final String message;

  DataError(this.message);

  @override
  List<Object> get props => [message];
}

class DataAvailable extends TVEpisodesDetailState {
  final TVEpisodes result;

  DataAvailable(this.result);

  @override
  List<Object> get props => [result];
}
