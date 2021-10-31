part of 'search_type_bloc.dart';
 
abstract class SearchTypeEvent extends Equatable {
  const SearchTypeEvent();
 
  @override
  List<Object> get props => [];
}

class SetCurrentSelection extends SearchTypeEvent {
  final String selection;
 
  SetCurrentSelection(this.selection);
 
  @override
  List<Object> get props => [selection];
}

class GetCurrentSelection extends SearchTypeEvent {}