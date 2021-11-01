import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_popular_tv_event.dart';
part 'home_popular_tv_state.dart';

class HomePopularTVBloc extends Bloc<HomePopularTVEvent, HomePopularTVState> {
  final GetPopularTV _getPopularTVs;
  HomePopularTVBloc(this._getPopularTVs) : super(DataPopularTVEmpty());

  @override
  Stream<HomePopularTVState> mapEventToState(
    HomePopularTVEvent event,
  ) async* {
    if (event is FetchPopularTVData) {
      yield DataPopularTVLoading();
      final result = await _getPopularTVs.execute();

      yield* result.fold(
        (failure) async* {
          yield DataPopularTVError(failure.message);
        },
        (data) async* {
          yield DataPopularTVAvailable(data);
        },
      );
    }
  }
}
