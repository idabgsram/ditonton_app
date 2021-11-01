import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_popular_movies_event.dart';
part 'home_popular_movies_state.dart';

class HomePopularMoviesBloc extends Bloc<HomePopularMoviesEvent, HomePopularMoviesState> {
  final GetPopularMovies _getPopularMovies;
  HomePopularMoviesBloc(this._getPopularMovies) : super(DataPopularMoviesEmpty());

  @override
  Stream<HomePopularMoviesState> mapEventToState(
    HomePopularMoviesEvent event,
  ) async* {
    if (event is FetchPopularMoviesData) {
      yield DataPopularMoviesLoading();
      final result = await _getPopularMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield DataPopularMoviesError(failure.message);
        },
        (data) async* {
          yield DataPopularMoviesAvailable(data);
        },
      );
    }
  }
}
