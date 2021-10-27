import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTVModel = TVModel(
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

  final tTV = TV(
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

  test('should be a subclass of TV entity', () async {
    final result = tTVModel.toEntity();
    expect(result, tTV);
  });
}
