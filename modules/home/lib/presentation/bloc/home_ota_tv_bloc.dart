import 'dart:async';

import 'package:tv_shows/domain/entities/tv.dart';
import 'package:tv_shows/domain/usecases/get_on_the_air_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_ota_tv_event.dart';
part 'home_ota_tv_state.dart';

class HomeOTATVBloc extends Bloc<HomeOTATVEvent, HomeOTATVState> {
  final GetOnTheAirTV _getOnTheAirTV;
  HomeOTATVBloc(this._getOnTheAirTV) : super(DataOTATVEmpty()) {
    on<FetchOTATVData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      FetchOTATVData event, Emitter<HomeOTATVState> emit) async {
    emit(DataOTATVLoading());
    final result = await _getOnTheAirTV.execute();

    result.fold(
      (failure) {
        emit(DataOTATVError(failure.message));
      },
      (data) {
        emit(DataOTATVAvailable(data));
      },
    );
  }
}
