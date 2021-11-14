import 'dart:async';

import 'package:tv_shows/domain/entities/tv.dart';
import 'package:tv_shows/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_top_rated_tv_event.dart';
part 'home_top_rated_tv_state.dart';

class HomeTopRatedTVBloc
    extends Bloc<HomeTopRatedTVEvent, HomeTopRatedTVState> {
  final GetTopRatedTV _getTopRatedTV;
  HomeTopRatedTVBloc(this._getTopRatedTV) : super(DataTopRatedTVEmpty()) {
    on<FetchTopRatedTVData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      FetchTopRatedTVData event, Emitter<HomeTopRatedTVState> emit) async {
    emit(DataTopRatedTVLoading());
    final result = await _getTopRatedTV.execute();

    result.fold(
      (failure) {
        emit(DataTopRatedTVError(failure.message));
      },
      (data) {
        emit(DataTopRatedTVAvailable(data));
      },
    );
  }
}
