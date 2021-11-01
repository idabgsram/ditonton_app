import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTVBloc extends Bloc<WatchlistTVEvent, WatchlistTVState> {
  final GetWatchlistTV _getWatchlistTV;
  WatchlistTVBloc(this._getWatchlistTV) : super(DataTVEmpty());

  @override
  Stream<WatchlistTVState> mapEventToState(
    WatchlistTVEvent event,
  ) async* {
    if (event is GetWatchlistTVData) {
      yield DataTVLoading();
      final result = await _getWatchlistTV.execute();

      yield* result.fold(
        (failure) async* {
          yield DataTVError(failure.message);
        },
        (data) async* {
          yield DataTVAvailable(data);
        },
      );
    }
  }
}
