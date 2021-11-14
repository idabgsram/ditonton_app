import 'package:dartz/dartz.dart';
import 'package:tv_shows/domain/entities/tv_seasons.dart';
import 'package:tv_shows/domain/repositories/tv_repository.dart';
import 'package:core/core.dart';

class GetTVSeasonsDetail {
  final TVRepository repository;

  GetTVSeasonsDetail(this.repository);

  Future<Either<Failure, TVSeasons>> execute(id, seasonNumber) {
    return repository.getTVSeasonsDetail(id, seasonNumber);
  }
}
