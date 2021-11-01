part of 'home_ota_tv_bloc.dart';

abstract class HomeOTATVState extends Equatable {
  const HomeOTATVState();

  @override
  List<Object> get props => [];
}

class DataOTATVEmpty extends HomeOTATVState {}

class DataOTATVLoading extends HomeOTATVState {}

class DataOTATVError extends HomeOTATVState {
  final String otaTVMessage;

  DataOTATVError(this.otaTVMessage);

  @override
  List<Object> get props => [otaTVMessage];
}

class DataOTATVAvailable extends HomeOTATVState {
  final List<TV> otaTVResult;

  DataOTATVAvailable(this.otaTVResult);

  @override
  List<Object> get props => [otaTVResult];
}
