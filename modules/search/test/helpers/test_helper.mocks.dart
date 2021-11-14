// Mocks generated by Mockito 5.0.16 from annotations
// in search/test/helpers/test_helper.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:core/core.dart' as _i5;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:movies/domain/entities/movie.dart' as _i6;
import 'package:movies/domain/entities/movie_detail.dart' as _i7;
import 'package:movies/domain/repositories/movie_repository.dart' as _i3;
import 'package:tv_shows/domain/entities/tv.dart' as _i9;
import 'package:tv_shows/domain/entities/tv_detail.dart' as _i10;
import 'package:tv_shows/domain/entities/tv_episodes.dart' as _i12;
import 'package:tv_shows/domain/entities/tv_seasons.dart' as _i11;
import 'package:tv_shows/domain/repositories/tv_repository.dart' as _i8;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [MovieRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMovieRepository extends _i1.Mock implements _i3.MovieRepository {
  MockMovieRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Movie>>> getNowPlayingMovies() =>
      (super.noSuchMethod(Invocation.method(#getNowPlayingMovies, []),
          returnValue: Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>.value(
              _FakeEither_0<_i5.Failure, List<_i6.Movie>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Movie>>> getPopularMovies() =>
      (super.noSuchMethod(Invocation.method(#getPopularMovies, []),
          returnValue: Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>.value(
              _FakeEither_0<_i5.Failure, List<_i6.Movie>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Movie>>> getTopRatedMovies() =>
      (super.noSuchMethod(Invocation.method(#getTopRatedMovies, []),
          returnValue: Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>.value(
              _FakeEither_0<_i5.Failure, List<_i6.Movie>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i7.MovieDetail>> getMovieDetail(
          int? id) =>
      (super.noSuchMethod(Invocation.method(#getMovieDetail, [id]),
          returnValue: Future<_i2.Either<_i5.Failure, _i7.MovieDetail>>.value(
              _FakeEither_0<_i5.Failure, _i7.MovieDetail>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i7.MovieDetail>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Movie>>> getMovieRecommendations(
          int? id) =>
      (super.noSuchMethod(Invocation.method(#getMovieRecommendations, [id]),
          returnValue: Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>.value(
              _FakeEither_0<_i5.Failure, List<_i6.Movie>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Movie>>> searchMovies(
          String? query) =>
      (super.noSuchMethod(Invocation.method(#searchMovies, [query]),
          returnValue: Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>.value(
              _FakeEither_0<_i5.Failure, List<_i6.Movie>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> saveWatchlist(
          _i7.MovieDetail? movie) =>
      (super.noSuchMethod(Invocation.method(#saveWatchlist, [movie]),
              returnValue: Future<_i2.Either<_i5.Failure, String>>.value(
                  _FakeEither_0<_i5.Failure, String>()))
          as _i4.Future<_i2.Either<_i5.Failure, String>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> removeWatchlist(
          _i7.MovieDetail? movie) =>
      (super.noSuchMethod(Invocation.method(#removeWatchlist, [movie]),
              returnValue: Future<_i2.Either<_i5.Failure, String>>.value(
                  _FakeEither_0<_i5.Failure, String>()))
          as _i4.Future<_i2.Either<_i5.Failure, String>>);
  @override
  _i4.Future<bool> isAddedToWatchlist(int? id) =>
      (super.noSuchMethod(Invocation.method(#isAddedToWatchlist, [id]),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Movie>>> getWatchlistMovies() =>
      (super.noSuchMethod(Invocation.method(#getWatchlistMovies, []),
          returnValue: Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>.value(
              _FakeEither_0<_i5.Failure, List<_i6.Movie>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.Movie>>>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [TVRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockTVRepository extends _i1.Mock implements _i8.TVRepository {
  MockTVRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>> getOnTheAirTVs() =>
      (super.noSuchMethod(Invocation.method(#getOnTheAirTVs, []),
              returnValue: Future<_i2.Either<_i5.Failure, List<_i9.TV>>>.value(
                  _FakeEither_0<_i5.Failure, List<_i9.TV>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>> getPopularTVs() =>
      (super.noSuchMethod(Invocation.method(#getPopularTVs, []),
              returnValue: Future<_i2.Either<_i5.Failure, List<_i9.TV>>>.value(
                  _FakeEither_0<_i5.Failure, List<_i9.TV>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>> getTopRatedTVs() =>
      (super.noSuchMethod(Invocation.method(#getTopRatedTVs, []),
              returnValue: Future<_i2.Either<_i5.Failure, List<_i9.TV>>>.value(
                  _FakeEither_0<_i5.Failure, List<_i9.TV>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i10.TVDetail>> getTVDetails(int? id) =>
      (super.noSuchMethod(Invocation.method(#getTVDetails, [id]),
              returnValue: Future<_i2.Either<_i5.Failure, _i10.TVDetail>>.value(
                  _FakeEither_0<_i5.Failure, _i10.TVDetail>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i10.TVDetail>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>> getTVRecommendations(
          int? id) =>
      (super.noSuchMethod(Invocation.method(#getTVRecommendations, [id]),
              returnValue: Future<_i2.Either<_i5.Failure, List<_i9.TV>>>.value(
                  _FakeEither_0<_i5.Failure, List<_i9.TV>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i11.TVSeasons>> getTVSeasonsDetail(
          int? tvId, int? seasonNumber) =>
      (super.noSuchMethod(
          Invocation.method(#getTVSeasonsDetail, [tvId, seasonNumber]),
          returnValue: Future<_i2.Either<_i5.Failure, _i11.TVSeasons>>.value(
              _FakeEither_0<_i5.Failure, _i11.TVSeasons>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i11.TVSeasons>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i12.TVEpisodes>> getTVEpisodesDetail(
          int? tvId, int? seasonNumber, int? epsNumber) =>
      (super.noSuchMethod(
          Invocation.method(
              #getTVEpisodesDetail, [tvId, seasonNumber, epsNumber]),
          returnValue: Future<_i2.Either<_i5.Failure, _i12.TVEpisodes>>.value(
              _FakeEither_0<_i5.Failure, _i12.TVEpisodes>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i12.TVEpisodes>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>> searchTVs(String? query) =>
      (super.noSuchMethod(Invocation.method(#searchTVs, [query]),
              returnValue: Future<_i2.Either<_i5.Failure, List<_i9.TV>>>.value(
                  _FakeEither_0<_i5.Failure, List<_i9.TV>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> saveTVWatchlist(
          _i10.TVDetail? tv) =>
      (super.noSuchMethod(Invocation.method(#saveTVWatchlist, [tv]),
              returnValue: Future<_i2.Either<_i5.Failure, String>>.value(
                  _FakeEither_0<_i5.Failure, String>()))
          as _i4.Future<_i2.Either<_i5.Failure, String>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> removeTVWatchlist(
          _i10.TVDetail? tv) =>
      (super.noSuchMethod(Invocation.method(#removeTVWatchlist, [tv]),
              returnValue: Future<_i2.Either<_i5.Failure, String>>.value(
                  _FakeEither_0<_i5.Failure, String>()))
          as _i4.Future<_i2.Either<_i5.Failure, String>>);
  @override
  _i4.Future<bool> isAddedToTVWatchlist(int? id) =>
      (super.noSuchMethod(Invocation.method(#isAddedToTVWatchlist, [id]),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>> getWatchlistTVs() =>
      (super.noSuchMethod(Invocation.method(#getWatchlistTVs, []),
              returnValue: Future<_i2.Either<_i5.Failure, List<_i9.TV>>>.value(
                  _FakeEither_0<_i5.Failure, List<_i9.TV>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i9.TV>>>);
  @override
  String toString() => super.toString();
}
