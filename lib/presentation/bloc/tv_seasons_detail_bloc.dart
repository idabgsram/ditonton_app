import 'dart:async';

import 'package:ditonton/domain/entities/tv_seasons.dart';
import 'package:ditonton/domain/usecases/get_tv_seasons_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'tv_seasons_detail_event.dart';
part 'tv_seasons_detail_state.dart';

class TVSeasonsDetailBloc
    extends Bloc<TVSeasonsDetailEvent, TVSeasonsDetailState> {
  final GetTVSeasonsDetail _getTVSeasonsDetail;
  TVSeasonsDetailBloc(this._getTVSeasonsDetail) : super(DataEmpty()) {
    on<FetchData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      FetchData event, Emitter<TVSeasonsDetailState> emit) async {
    final id = event.id;
    final seasonNumber = event.seasonNumber;
    emit(DataLoading());
    final result = await _getTVSeasonsDetail.execute(id, seasonNumber);

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
