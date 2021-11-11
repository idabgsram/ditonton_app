import 'dart:async';

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_popular_tv_event.dart';
part 'home_popular_tv_state.dart';

class HomePopularTVBloc extends Bloc<HomePopularTVEvent, HomePopularTVState> {
  final GetPopularTV _getPopularTVs;
  HomePopularTVBloc(this._getPopularTVs) : super(DataPopularTVEmpty()) {
    on<FetchPopularTVData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      FetchPopularTVData event, Emitter<HomePopularTVState> emit) async {
    emit(DataPopularTVLoading());
    final result = await _getPopularTVs.execute();

    result.fold(
      (failure) {
        emit(DataPopularTVError(failure.message));
      },
      (data) {
        emit(DataPopularTVAvailable(data));
      },
    );
  }
}
