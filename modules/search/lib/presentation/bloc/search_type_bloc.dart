import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_type_event.dart';
part 'search_type_state.dart';

class SearchTypeBloc extends Bloc<SearchTypeEvent, SearchTypeState> {
  SearchTypeBloc() : super(SearchTypeState('Movies')) {
    on<GetSearchType>(_getSearchType);
    on<SetSearchType>(_setSearchType);
  }

  String _currentSelection = 'Movies';

  FutureOr<void> _getSearchType(
      GetSearchType event, Emitter<SearchTypeState> emit) async {
    emit(SearchTypeState(_currentSelection));
  }

  FutureOr<void> _setSearchType(
      SetSearchType event, Emitter<SearchTypeState> emit) async {
    _currentSelection = event.selection;
    emit(SearchTypeState(_currentSelection));
  }
}
