import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_top_rated_tv_event.dart';
part 'home_top_rated_tv_state.dart';

class HomeTopRatedTVBloc extends Bloc<HomeTopRatedTVEvent, HomeTopRatedTVState> {
  final GetTopRatedTV _getTopRatedTV;
  HomeTopRatedTVBloc(this._getTopRatedTV) : super(DataTopRatedTVEmpty());

  @override
  Stream<HomeTopRatedTVState> mapEventToState(
    HomeTopRatedTVEvent event,
  ) async* {
    if (event is FetchTopRatedTVData) {
      yield DataTopRatedTVLoading();
      final result = await _getTopRatedTV.execute();

      yield* result.fold(
        (failure) async* {
          yield DataTopRatedTVError(failure.message);
        },
        (data) async* {
          yield DataTopRatedTVAvailable(data);
        },
      );
    }
  }
}
