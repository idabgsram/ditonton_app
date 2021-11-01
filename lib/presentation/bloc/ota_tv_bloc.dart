import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'ota_tv_event.dart';
part 'ota_tv_state.dart';

class OTATVBloc extends Bloc<OTATVEvent, OTATVState> {
  final GetOnTheAirTV _getOnTheAirTV;
  OTATVBloc(this._getOnTheAirTV) : super(DataEmpty());

  @override
  Stream<OTATVState> mapEventToState(
    OTATVEvent event,
  ) async* {
    if (event is FetchData) {
      yield DataLoading();
      final result = await _getOnTheAirTV.execute();

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
