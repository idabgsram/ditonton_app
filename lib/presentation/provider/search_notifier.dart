import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:flutter/foundation.dart';

class SearchNotifier extends ChangeNotifier {
  final SearchMovies searchMovies;
  final SearchTVs searchTVs;

  SearchNotifier({required this.searchMovies, required this.searchTVs});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<dynamic> _searchResult = [];
  List<dynamic> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  String _currentSelection = 'Movies';
  String get currentSelection => _currentSelection;

  void setCurrentSelection(String? selection) {
     _searchResult = [];
    _currentSelection = selection ?? 'Movies';
    notifyListeners();
  }

  bool get isMovies{
    return _currentSelection == 'Movies';
  }

  Future<void> fetchSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    if (_currentSelection == 'TV Shows') {
      final result = await searchTVs.execute(query);
      result.fold(
        (failure) {
          _message = failure.message;
          _state = RequestState.Error;
          notifyListeners();
        },
        (data) {
          _searchResult = data;
          _state = RequestState.Loaded;
          notifyListeners();
        },
      );
    } else {
      final result = await searchMovies.execute(query);
      result.fold(
        (failure) {
          _message = failure.message;
          _state = RequestState.Error;
          notifyListeners();
        },
        (data) {
          _searchResult = data;
          _state = RequestState.Loaded;
          notifyListeners();
        },
      );
    }
  }
}
