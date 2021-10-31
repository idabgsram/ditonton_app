import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'search_type_event.dart';

class SearchTypeBloc extends Bloc<SearchTypeEvent, String> {
  SearchTypeBloc() : super('Movies');

  String _currentSelection = 'Movies';

  @override
  Stream<String> mapEventToState(
    SearchTypeEvent event,
  ) async* {
    if (event is SetCurrentSelection) {
      _currentSelection = event.selection;
    }
    yield _currentSelection;
  }

    @override
  Stream<Transition<SearchTypeEvent, String>> transformEvents(
    Stream<SearchTypeEvent> events,
    TransitionFunction<SearchTypeEvent, String> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}
