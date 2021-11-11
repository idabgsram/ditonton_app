import 'dart:async';

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'tv_detail_recommendations_event.dart';
part 'tv_detail_recommendations_state.dart';

class TVDetailRecommendationsBloc
    extends Bloc<TVDetailRecommendationsEvent, TVDetailRecommendationsState> {
  final GetTVRecommendations _getTVRecommendations;
  TVDetailRecommendationsBloc(this._getTVRecommendations)
      : super(DataRecommendationsEmpty()) {
    on<FetchRecommendationsData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(FetchRecommendationsData event,
      Emitter<TVDetailRecommendationsState> emit) async {
    emit(DataRecommendationsLoading());
    final result = await _getTVRecommendations.execute(event.id);

    result.fold(
      (failure) {
        emit(DataRecommendationsError(failure.message));
      },
      (data) {
        emit(DataRecommendationsAvailable(data));
      },
    );
  }
}
