import 'package:ditonton/domain/entities/tv_episodes.dart';
import 'package:ditonton/domain/usecases/get_tv_episodes_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'tv_episodes_detail_event.dart';
part 'tv_episodes_detail_state.dart';

class TVEpisodesDetailBloc
    extends Bloc<TVEpisodesDetailEvent, TVEpisodesDetailState> {
  final GetTVEpisodesDetail _getTVEpisodesDetail;
  TVEpisodesDetailBloc(this._getTVEpisodesDetail) : super(DataEmpty());

  @override
  Stream<TVEpisodesDetailState> mapEventToState(
    TVEpisodesDetailEvent event,
  ) async* {
    if (event is FetchData) {
      final id = event.id;
      final seasonNumber = event.seasonNumber;
      final epsNumber = event.epsNumber;
      yield DataLoading();
      final result =
          await _getTVEpisodesDetail.execute(id, seasonNumber, epsNumber);

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
