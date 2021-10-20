
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_episodes.dart';
import 'package:ditonton/domain/usecases/get_tv_episodes_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TVEpisodesDetailNotifier extends ChangeNotifier {
  final GetTVEpisodesDetail getTVEpisodesDetail;

  TVEpisodesDetailNotifier({
    required this.getTVEpisodesDetail
  });

  late TVEpisodes _tvEpisodesData;
  TVEpisodes get tvEpisodesData => _tvEpisodesData;

  RequestState _tvEpisodesState = RequestState.Empty;
  RequestState get tvEpisodesState => _tvEpisodesState;

  String _message = '';
  String get message => _message;

  Future<void> fetchTVEpisodesDetail(int id, int seasonNumber, int epsNumber) async {
    _tvEpisodesState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTVEpisodesDetail.execute(id, seasonNumber, epsNumber);
    detailResult.fold(
      (failure) {
        _tvEpisodesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _tvEpisodesData = tv;
        _tvEpisodesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

}
