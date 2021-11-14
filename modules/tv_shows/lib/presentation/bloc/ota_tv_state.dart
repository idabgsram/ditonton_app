part of 'ota_tv_bloc.dart';

abstract class OTATVState extends Equatable {
  const OTATVState();

  @override
  List<Object> get props => [];
}

class DataEmpty extends OTATVState {}

class DataLoading extends OTATVState {}

class DataError extends OTATVState {
  final String message;

  DataError(this.message);

  @override
  List<Object> get props => [message];
}

class DataAvailable extends OTATVState {
  final List<TV> result;

  DataAvailable(this.result);

  @override
  List<Object> get props => [result];
}
