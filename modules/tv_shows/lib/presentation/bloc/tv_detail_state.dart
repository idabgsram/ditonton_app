part of 'tv_detail_bloc.dart';

abstract class TVDetailState extends Equatable {
  const TVDetailState();

  @override
  List<Object> get props => [];
}

class DataEmpty extends TVDetailState {}

class DataLoading extends TVDetailState {}

class DataError extends TVDetailState {
  final String message;

  DataError(this.message);

  @override
  List<Object> get props => [message];
}

class DataAvailable extends TVDetailState {
  final TVDetail result;

  DataAvailable(this.result);

  @override
  List<Object> get props => [result];
}
