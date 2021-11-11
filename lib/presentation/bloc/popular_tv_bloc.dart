import 'dart:async';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTVBloc extends Bloc<PopularTVEvent, PopularTVState> {
  final GetPopularTV _getPopularTVs;
  PopularTVBloc(this._getPopularTVs) : super(DataEmpty()){
    on<FetchData>(_onFetchEvent);
  }

  FutureOr<void> _onFetchEvent(
      FetchData event, Emitter<PopularTVState> emit) async {
    emit(DataLoading());
    final result = await _getPopularTVs.execute();

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
