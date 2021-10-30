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

  SearchBloc(this._searchMovies, this._searchTVs) : super(SearchEmpty());

  String _currentSelection = 'Movies';
  String get currentSelection => _currentSelection;
  
  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is OnQueryChanged) {
      final query = event.query;

      yield SearchLoading();
      final result = _currentSelection == 'Movies'?await _searchMovies.execute(query):await _searchTVs.execute(query);

      yield* result.fold(
        (failure) async* {
          yield SearchError(failure.message);
        },
        (data) async* {
          yield SearchHasData(data);
        },
      );
    }
    if (event is SetCurrentSelection) {
      _currentSelection = event.selection;
    }
  }

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
    Stream<SearchEvent> events,
    TransitionFunction<SearchEvent, SearchState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}
