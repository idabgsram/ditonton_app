import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_ota_tv_event.dart';
part 'home_ota_tv_state.dart';

class HomeOTATVBloc extends Bloc<HomeOTATVEvent, HomeOTATVState> {
  final GetOnTheAirTV _getOnTheAirTV;
  HomeOTATVBloc(this._getOnTheAirTV) : super(DataOTATVEmpty());

  @override
  Stream<HomeOTATVState> mapEventToState(
    HomeOTATVEvent event,
  ) async* {
    if (event is FetchOTATVData) {
      yield DataOTATVLoading();
      final result = await _getOnTheAirTV.execute();

      yield* result.fold(
        (failure) async* {
          yield DataOTATVError(failure.message);
        },
        (data) async* {
          yield DataOTATVAvailable(data);
        },
      );
    }
  }
}
