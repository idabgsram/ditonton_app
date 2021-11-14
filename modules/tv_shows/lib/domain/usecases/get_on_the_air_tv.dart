import 'package:dartz/dartz.dart';
import 'package:tv_shows/domain/entities/tv.dart';
import 'package:tv_shows/domain/repositories/tv_repository.dart';
import 'package:core/core.dart';

class GetOnTheAirTV {
  final TVRepository repository;

  GetOnTheAirTV(this.repository);

  Future<Either<Failure, List<TV>>> execute() {
    return repository.getOnTheAirTVs();
  }
}
