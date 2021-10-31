part of 'search_bloc.dart';
 
abstract class SearchEvent extends Equatable {
  const SearchEvent();
 
  @override
  List<Object> get props => [];
}
 
class OnQueryChanged extends SearchEvent {
  final String query, searchType;
 
  OnQueryChanged(this.query, this.searchType);
 
  @override
  List<Object> get props => [query,searchType];
}

class OnRefreshChanged extends SearchEvent {
  final String searchType;
 
  OnRefreshChanged(this.searchType);
 
  @override
  List<Object> get props => [searchType];
}