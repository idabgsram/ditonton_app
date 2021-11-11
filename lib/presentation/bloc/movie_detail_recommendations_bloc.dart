import 'dart:async';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_recommendations_event.dart';
part 'movie_detail_recommendations_state.dart';

class MovieDetailRecommendationsBloc extends Bloc<
    MovieDetailRecommendationsEvent, MovieDetailRecommendationsState> {
  final GetMovieRecommendations _getMovieRecommendations;
  MovieDetailRecommendationsBloc(this._getMovieRecommendations)
      : super(DataRecommendationsEmpty()) {
    on<FetchRecommendationsData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(FetchRecommendationsData event,
      Emitter<MovieDetailRecommendationsState> emit) async {
    emit(DataRecommendationsLoading());
    final result = await _getMovieRecommendations.execute(event.id);

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
