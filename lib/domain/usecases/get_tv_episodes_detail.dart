import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_episodes.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetTVEpisodesDetail {
  final TVRepository repository;

  GetTVEpisodesDetail(this.repository);

  Future<Either<Failure, TVEpisodes>> execute(id, seasonNumber, epsNumber) {
    return repository.getTVEpisodesDetail(id, seasonNumber, epsNumber);
  }
}
