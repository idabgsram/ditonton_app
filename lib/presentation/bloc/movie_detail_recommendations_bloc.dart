import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_recommendations_event.dart';
part 'movie_detail_recommendations_state.dart';

class MovieDetailRecommendationsBloc extends Bloc<MovieDetailRecommendationsEvent, MovieDetailRecommendationsState> {
  final GetMovieRecommendations _getMovieRecommendations;
  MovieDetailRecommendationsBloc(this._getMovieRecommendations) : super(DataRecommendationsEmpty());

  @override
  Stream<MovieDetailRecommendationsState> mapEventToState(
    MovieDetailRecommendationsEvent event,
  ) async* {
    if (event is FetchRecommendationsData) {
      yield DataRecommendationsLoading();
      final result = await _getMovieRecommendations.execute(event.id);

      yield* result.fold(
        (failure) async* {
          yield DataRecommendationsError(failure.message);
        },
        (data) async* {
          yield DataRecommendationsAvailable(data);
        },
      );
    }
  }
}
