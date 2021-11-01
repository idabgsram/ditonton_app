import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_top_rated_movies_event.dart';
part 'home_top_rated_movies_state.dart';

class HomeTopRatedMoviesBloc extends Bloc<HomeTopRatedMoviesEvent, HomeTopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;
  HomeTopRatedMoviesBloc(this._getTopRatedMovies) : super(DataTopRatedMoviesEmpty());

  @override
  Stream<HomeTopRatedMoviesState> mapEventToState(
    HomeTopRatedMoviesEvent event,
  ) async* {
    if (event is FetchTopRatedMoviesData) {
      yield DataTopRatedMoviesLoading();
      final result = await _getTopRatedMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield DataTopRatedMoviesError(failure.message);
        },
        (data) async* {
          yield DataTopRatedMoviesAvailable(data);
        },
      );
    }
  }
}
