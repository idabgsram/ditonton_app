import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_episodes.dart';
import 'package:ditonton/domain/entities/tv_seasons.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';

class TVRepositoryImpl implements TVRepository {
  final TVRemoteDataSource remoteDataSource;
  final TVLocalDataSource localDataSource;

  TVRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TV>>> getOnTheAirTVs() async {
    try {
      final result = await remoteDataSource.getOnTheAirTV();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TVDetail>> getTVDetails(int id) async {
    try {
      final result = await remoteDataSource.getTVDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getTVRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getTVRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getPopularTVs() async {
    try {
      final result = await remoteDataSource.getPopularTV();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getTopRatedTVs() async {
    try {
      final result = await remoteDataSource.getTopRatedTV();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TVSeasons>> getTVSeasonsDetail(int tvId, int seasonNumber) async {
    try {
      final result = await remoteDataSource.getTVSeasonsDetail(tvId, seasonNumber);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TVEpisodes>> getTVEpisodesDetail(int tvId, int seasonNumber, int epsNumber) async {
    try {
      final result = await remoteDataSource.getTVEpisodesDetail(tvId, seasonNumber, epsNumber);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> searchTVs(String query) async {
    try {
      final result = await remoteDataSource.searchTV(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> saveTVWatchlist(TVDetail tv) async {
    try {
      final result =
          await localDataSource.insertTVWatchlist(TVTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> removeTVWatchlist(TVDetail tv) async {
    try {
      final result =
          await localDataSource.removeTVWatchlist(TVTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToTVWatchlist(int id) async {
    final result = await localDataSource.getTVById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<TV>>> getWatchlistTVs() async {
    final result = await localDataSource.getWatchlistTVs();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}
