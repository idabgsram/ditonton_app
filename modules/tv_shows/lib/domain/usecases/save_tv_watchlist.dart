import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv_shows/domain/entities/tv_detail.dart';
import 'package:tv_shows/domain/repositories/tv_repository.dart';

class SaveTVWatchlist {
  final TVRepository repository;

  SaveTVWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TVDetail tv) {
    return repository.saveTVWatchlist(tv);
  }
}
