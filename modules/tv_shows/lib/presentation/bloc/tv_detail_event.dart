part of 'tv_detail_bloc.dart';

abstract class TVDetailEvent extends Equatable {
  const TVDetailEvent();
}

class FetchDetailData extends TVDetailEvent {
  final int id;
 
  FetchDetailData(this.id);
  @override
  List<Object> get props => [id];
}
