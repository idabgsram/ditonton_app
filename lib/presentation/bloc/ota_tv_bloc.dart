import 'dart:async';

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'ota_tv_event.dart';
part 'ota_tv_state.dart';

class OTATVBloc extends Bloc<OTATVEvent, OTATVState> {
  final GetOnTheAirTV _getOnTheAirTV;
  OTATVBloc(this._getOnTheAirTV) : super(DataEmpty()) {
    on<FetchData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      FetchData event, Emitter<OTATVState> emit) async {
    emit(DataLoading());
    final result = await _getOnTheAirTV.execute();

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
