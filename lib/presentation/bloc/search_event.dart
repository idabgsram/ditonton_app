part of 'search_bloc.dart';
 
abstract class SearchEvent extends Equatable {
  const SearchEvent();
 
  @override
  List<Object> get props => [];
}
 
class OnQueryChanged extends SearchEvent {
  final String query;
 
  OnQueryChanged(this.query);
 
  @override
  List<Object> get props => [query];
}

class SetCurrentSelection extends SearchEvent {
  final String selection;
 
  SetCurrentSelection(this.selection);
 
  @override
  List<Object> get props => [selection];
}