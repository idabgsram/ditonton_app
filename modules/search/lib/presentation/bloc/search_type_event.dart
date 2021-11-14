part of 'search_type_bloc.dart';

abstract class SearchTypeEvent extends Equatable {
  const SearchTypeEvent();
}

class SetSearchType extends SearchTypeEvent {
  final String selection;

  SetSearchType(this.selection);

  @override
  List<Object> get props => [selection];
}

class GetSearchType extends SearchTypeEvent {
  @override
  List<Object> get props => [];
}
