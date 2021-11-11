part of 'search_type_bloc.dart';


class SearchTypeState extends Equatable {
  final String type;

  SearchTypeState(this.type);

  @override
  List<Object> get props => [type];
}
