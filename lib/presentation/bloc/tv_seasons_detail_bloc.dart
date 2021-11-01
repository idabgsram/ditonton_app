import 'package:ditonton/domain/entities/tv_seasons.dart';
import 'package:ditonton/domain/usecases/get_tv_seasons_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'tv_seasons_detail_event.dart';
part 'tv_seasons_detail_state.dart';

class TVSeasonsDetailBloc
    extends Bloc<TVSeasonsDetailEvent, TVSeasonsDetailState> {
  final GetTVSeasonsDetail _getTVSeasonsDetail;
  TVSeasonsDetailBloc(this._getTVSeasonsDetail) : super(DataEmpty());

  @override
  Stream<TVSeasonsDetailState> mapEventToState(
    TVSeasonsDetailEvent event,
  ) async* {
    if (event is FetchData) {
      final id = event.id;
      final seasonNumber = event.seasonNumber;
      yield DataLoading();
      final result =
          await _getTVSeasonsDetail.execute(id, seasonNumber);

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
