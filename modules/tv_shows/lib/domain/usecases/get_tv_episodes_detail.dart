import 'package:dartz/dartz.dart';
import 'package:tv_shows/domain/entities/tv_episodes.dart';
import 'package:tv_shows/domain/repositories/tv_repository.dart';
import 'package:core/core.dart';

class GetTVEpisodesDetail {
  final TVRepository repository;

  GetTVEpisodesDetail(this.repository);

  Future<Either<Failure, TVEpisodes>> execute(id, seasonNumber, epsNumber) {
    return repository.getTVEpisodesDetail(id, seasonNumber, epsNumber);
  }
}
