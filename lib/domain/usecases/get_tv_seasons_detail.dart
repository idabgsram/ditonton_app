import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_seasons.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetTVSeasonsDetail {
  final TVRepository repository;

  GetTVSeasonsDetail(this.repository);

  Future<Either<Failure, TVSeasons>> execute(id, seasonNumber) {
    return repository.getTVSeasonsDetail(id, seasonNumber);
  }
}
