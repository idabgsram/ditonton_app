import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies _getPopularMovies;
  PopularMoviesBloc(this._getPopularMovies) : super(DataEmpty());

  @override
  Stream<PopularMoviesState> mapEventToState(
    PopularMoviesEvent event,
  ) async* {
    if (event is FetchData) {
      yield DataLoading();
      final result = await _getPopularMovies.execute();

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
