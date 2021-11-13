part of 'home_ota_tv_bloc.dart';

abstract class HomeOTATVEvent extends Equatable {
  const HomeOTATVEvent();
}

class FetchOTATVData extends HomeOTATVEvent {
  @override
  List<Object> get props => [];
}
