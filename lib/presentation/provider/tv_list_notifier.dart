import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter/material.dart';

class TVListNotifier extends ChangeNotifier {
  var _onTheAirTVs = <TV>[];
  List<TV> get onTheAirTVs => _onTheAirTVs;

  RequestState _onTheAirState = RequestState.Empty;
  RequestState get onTheAirState => _onTheAirState;

  var _popularTVs = <TV>[];
  List<TV> get popularTVs => _popularTVs;

  RequestState _popularTVsState = RequestState.Empty;
  RequestState get popularTVsState => _popularTVsState;

  var _topRatedTVs = <TV>[];
  List<TV> get topRatedTVs => _topRatedTVs;

  RequestState _topRatedTVState = RequestState.Empty;
  RequestState get topRatedTVsState => _topRatedTVState;

  String _message = '';
  String get message => _message;

  TVListNotifier({
    required this.getOnTheAirTVs,
    required this.getPopularTVs,
    required this.getTopRatedTVs,
  });

  final GetOnTheAirTV getOnTheAirTVs;
  final GetPopularTV getPopularTVs;
  final GetTopRatedTV getTopRatedTVs;

  Future<void> fetchOnTheAirTVs() async {
    _onTheAirState = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAirTVs.execute();
    result.fold(
      (failure) {
        _onTheAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _onTheAirState = RequestState.Loaded;
        _onTheAirTVs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTVs() async {
    _popularTVsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTVs.execute();
    result.fold(
      (failure) {
        _popularTVsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _popularTVsState = RequestState.Loaded;
        _popularTVs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTVs() async {
    _topRatedTVState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTVs.execute();
    result.fold(
      (failure) {
        _topRatedTVState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _topRatedTVState = RequestState.Loaded;
        _topRatedTVs = tvsData;
        notifyListeners();
      },
    );
  }
}
