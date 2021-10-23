import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_detail_episodes.dart';
import 'package:ditonton/domain/entities/tv_detail_season.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTV = TV(
  backdropPath: '/4QNBIgt5fwgNCN3OSU6BTFv0NGR.jpg',
  genreIds: [16, 10759],
  id: 888,
  name: 'Spider-Man',
  overview:
      'Bitten by a radioactive spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.',
  popularity: 82.967,
  posterPath: '/wXthtEN5kdWA1bHz03lkuCJS6hA.jpg',
  firstAirDate: '1994-11-19',
  originalName: 'Spider-Man',
  originalLanguage: "en",
  voteAverage: 8.3,
  voteCount: 633,
  originCountry: ["US"],
);

final testTVList = [testTV];

final testTVDetail = TVDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalName: 'originalTitle',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  numberOfSeasons: 1,
  numberOfEpisodes: 2,
  name: 'name',
  voteAverage: 1,
  voteCount: 1,
  episodeRunTime: [60],
  firstAirDate: "2021-12-01",
  inProduction: true,
  lastEpisodeToAir: TVDetailEpisodes(
      airDate: "2002-12-01",
      episodeNumber: 1,
      id: 1,
      name: "name",
      overview: "overview",
      stillPath: "stillPath"),
  nextEpisodeToAir: TVDetailEpisodes(
      airDate: "2002-12-08",
      episodeNumber: 2,
      id: 2,
      name: "name",
      overview: "overview",
      stillPath: "stillPath"),
  seasons: [
    TVDetailSeason(
        airDate: "airDate",
        episodeCount: 2,
        id: 1,
        name: "name",
        overview: "overview",
        posterPath: "posterPath",
        seasonNumber: 1)
  ],
  type: "type",
);

final testWatchlistTV = TV.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVTable = TVTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
