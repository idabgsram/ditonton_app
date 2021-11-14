import 'dart:async';

import 'package:tv_shows/domain/entities/tv_episodes.dart';
import 'package:tv_shows/domain/usecases/get_tv_episodes_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'tv_episodes_detail_event.dart';
part 'tv_episodes_detail_state.dart';

class TVEpisodesDetailBloc
    extends Bloc<TVEpisodesDetailEvent, TVEpisodesDetailState> {
  final GetTVEpisodesDetail _getTVEpisodesDetail;
  TVEpisodesDetailBloc(this._getTVEpisodesDetail) : super(DataEmpty()) {
    on<FetchData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      FetchData event, Emitter<TVEpisodesDetailState> emit) async {
    final id = event.id;
    final seasonNumber = event.seasonNumber;
    final epsNumber = event.epsNumber;
    emit(DataLoading());
    final result =
        await _getTVEpisodesDetail.execute(id, seasonNumber, epsNumber);

    result.fold(
      (failure) {
        emit(DataError(failure.message));
      },
      (data) {
        emit(DataAvailable(data));
      },
    );
  }
}
