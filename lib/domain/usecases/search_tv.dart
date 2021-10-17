import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class SearchTVs {
  final TVRepository repository;

  SearchTVs(this.repository);

  Future<Either<Failure, List<TV>>> execute(String query) {
    return repository.searchTVs(query);
  }
}
