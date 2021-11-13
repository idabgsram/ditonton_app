import 'dart:async';

import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;
  final SearchTVs _searchTVs;

  String searchQuery = '';
  String searchType = 'Movies';

  SearchBloc(this._searchMovies, this._searchTVs) : super(SearchEmpty()) {
    on<OnQueryChanged>(_onQueryChanged,
        transformer: debounce(const Duration(milliseconds: 300)));
    on<OnRefreshChanged>(_onRefreshChanged);
  }
  EventTransformer<MyEvent> debounce<MyEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  FutureOr<void> _onQueryChanged(
      OnQueryChanged event, Emitter<SearchState> emit) async {
    searchQuery = event.query;

    emit(SearchLoading());
    final result = searchType == 'Movies'
        ? await _searchMovies.execute(searchQuery)
        : await _searchTVs.execute(searchQuery);
    if (searchQuery.length < 1) {
      emit(SearchEmpty());
      return;
    }
    result.fold(
      (failure) {
        emit(SearchError(failure.message));
      },
      (data) {
        emit(SearchHasData(data));
      },
    );
  }

  FutureOr<void> _onRefreshChanged(
      OnRefreshChanged event, Emitter<SearchState> emit) async {
    searchType = event.searchType;
    emit(SearchLoading());
    final result = searchType == 'Movies'
        ? await _searchMovies.execute(searchQuery)
        : await _searchTVs.execute(searchQuery);

    if (searchQuery.length < 1) {
      emit(SearchEmpty());
      return;
    }
    result.fold(
      (failure) {
        emit(SearchError(failure.message));
      },
      (data) {
        emit(SearchHasData(data));
      },
    );
  }
}
