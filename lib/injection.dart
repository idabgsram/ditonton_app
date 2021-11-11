import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_tv_episodes_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_seasons_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:ditonton/presentation/bloc/home_now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/home_ota_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/home_popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/home_popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/home_top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/home_top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/ota_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/search_bloc.dart';
import 'package:ditonton/presentation/bloc/search_type_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_episodes_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_seasons_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => HomeNowPlayingMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => HomePopularMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => HomeTopRatedMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => HomeOTATVBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => HomePopularTVBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => HomeTopRatedTVBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailRecommendationsBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailWatchlistBloc(
      locator(),
      locator(),
      locator()
    ),
  );
  locator.registerFactory(
    () => PopularMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTVBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => TVDetailBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TVDetailRecommendationsBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TVDetailWatchlistBloc(
      locator(),
      locator(),
      locator()
    ),
  );
  locator.registerFactory(
    () => PopularTVBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => OTATVBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTVBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TVSeasonsDetailBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TVEpisodesDetailBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => SearchBloc(
      locator(),
      locator(),
    ),
  );

  locator.registerFactory(
    () => SearchTypeBloc(),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetOnTheAirTV(locator()));
  locator.registerLazySingleton(() => GetPopularTV(locator()));
  locator.registerLazySingleton(() => GetTopRatedTV(locator()));
  locator.registerLazySingleton(() => GetTVDetail(locator()));
  locator.registerLazySingleton(() => GetTVRecommendations(locator()));
  locator.registerLazySingleton(() => GetTVSeasonsDetail(locator()));
  locator.registerLazySingleton(() => GetTVEpisodesDetail(locator()));
  locator.registerLazySingleton(() => SearchTVs(locator()));
  locator.registerLazySingleton(() => GetTVWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveTVWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTVWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTV(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TVRepository>(
    () => TVRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl());
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TVRemoteDataSource>(
      () => TVRemoteDataSourceImpl());
  locator.registerLazySingleton<TVLocalDataSource>(
      () => TVLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
