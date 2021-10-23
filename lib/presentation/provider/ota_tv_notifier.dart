import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:flutter/foundation.dart';

class OTATVNotifier extends ChangeNotifier {
  final GetOnTheAirTV getOTATV;

  OTATVNotifier(this.getOTATV);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TV> _tv = [];
  List<TV> get tvList => _tv;

  String _message = '';
  String get message => _message;

  Future<void> fetchOTATV() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getOTATV.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _tv = tvData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
