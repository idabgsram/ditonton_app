import 'dart:async';

import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TVDetailBloc extends Bloc<TVDetailEvent, TVDetailState> {
  final GetTVDetail _getTVDetail;
  TVDetailBloc(this._getTVDetail) : super(DataEmpty()) {
    on<FetchDetailData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      FetchDetailData event, Emitter<TVDetailState> emit) async {
    emit(DataLoading());
    final result = await _getTVDetail.execute(event.id);

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
