import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_seasons.dart';
import 'package:ditonton/domain/usecases/get_tv_seasons_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TVSeasonsDetailNotifier extends ChangeNotifier {
  final GetTVSeasonsDetail getTVSeasonsDetail;

  TVSeasonsDetailNotifier({required this.getTVSeasonsDetail});

  late TVSeasons _tvSeasonsData;
  TVSeasons get tvSeasonsData => _tvSeasonsData;

  RequestState _tvSeasonsState = RequestState.Empty;
  RequestState get tvSeasonsState => _tvSeasonsState;

  String _message = '';
  String get message => _message;

  Future<void> fetchTVSeasonsDetail(int id, int seasonNumber) async {
    _tvSeasonsState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTVSeasonsDetail.execute(id, seasonNumber);
    detailResult.fold(
      (failure) {
        _tvSeasonsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _tvSeasonsData = tv;
        _tvSeasonsState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
