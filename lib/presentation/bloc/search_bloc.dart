import 'dart:async';

import 'package:ditonton/domain/entities/movie.dart';
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

  String _searchQuery = '';
  String _searchType = 'Movies';

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
    _searchQuery = event.query;
    emit(SearchLoading());
    final result = _searchType == 'Movies'
        ? await _searchMovies.execute(_searchQuery)
        : await _searchTVs.execute(_searchQuery);

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
    _searchType = event.searchType;

    emit(SearchLoading());
    final result = _searchType == 'Movies'
        ? await _searchMovies.execute(_searchQuery)
        : await _searchTVs.execute(_searchQuery);

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
