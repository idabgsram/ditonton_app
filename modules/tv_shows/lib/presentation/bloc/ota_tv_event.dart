part of 'ota_tv_bloc.dart';

abstract class OTATVEvent extends Equatable {
  const OTATVEvent();
}

class FetchData extends OTATVEvent {
  @override
  List<Object> get props => [];
}
