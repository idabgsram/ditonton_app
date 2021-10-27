import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_episodes.dart';
import 'package:ditonton/domain/entities/tv_seasons.dart';

abstract class TVRepository {
  Future<Either<Failure, List<TV>>> getOnTheAirTVs();
  Future<Either<Failure, List<TV>>> getPopularTVs();
  Future<Either<Failure, List<TV>>> getTopRatedTVs();
  Future<Either<Failure, TVDetail>> getTVDetails(int id);
  Future<Either<Failure, List<TV>>> getTVRecommendations(int id);
  Future<Either<Failure, TVSeasons>> getTVSeasonsDetail(
      int tvId, int seasonNumber);
  Future<Either<Failure, TVEpisodes>> getTVEpisodesDetail(
      int tvId, int seasonNumber, int epsNumber);
  Future<Either<Failure, List<TV>>> searchTVs(String query);
  Future<Either<Failure, String>> saveTVWatchlist(TVDetail tv);
  Future<Either<Failure, String>> removeTVWatchlist(TVDetail tv);
  Future<bool> isAddedToTVWatchlist(int id);
  Future<Either<Failure, List<TV>>> getWatchlistTVs();
}
