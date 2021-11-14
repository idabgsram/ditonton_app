part of 'search_bloc.dart';
 
abstract class SearchEvent extends Equatable {
  const SearchEvent();
}
 
class OnQueryChanged extends SearchEvent {
  final String query;
 
  OnQueryChanged(this.query);
 
  @override
  List<Object> get props => [query];
}

class OnRefreshChanged extends SearchEvent {
  final String searchType;
 
  OnRefreshChanged(this.searchType);
 
  @override
  List<Object> get props => [searchType];
}