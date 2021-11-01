import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTVBloc extends Bloc<TopRatedTVEvent, TopRatedTVState> {
  final GetTopRatedTV _getTopRatedTV;
  TopRatedTVBloc(this._getTopRatedTV) : super(DataEmpty());

  @override
  Stream<TopRatedTVState> mapEventToState(
    TopRatedTVEvent event,
  ) async* {
    if (event is FetchData) {
      yield DataLoading();
      final result = await _getTopRatedTV.execute();

      yield* result.fold(
        (failure) async* {
          yield DataError(failure.message);
        },
        (data) async* {
          yield DataAvailable(data);
        },
      );
    }
  }
}
