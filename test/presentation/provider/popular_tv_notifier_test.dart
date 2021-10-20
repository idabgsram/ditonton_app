import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTV])
void main() {
  late MockGetPopularTV mockGetPopularTVs;
  late PopularTVNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTVs = MockGetPopularTV();
    notifier = PopularTVNotifier(mockGetPopularTVs)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTV = TV(
    backdropPath: '/bAckDrop.jpg',
    genreIds: [1, 2, 3],
    id: 69,
    name: 'nameTV',
    overview: 'gang gang woo',
    popularity: 82.967,
    posterPath: '/teeeest.jpg',
    firstAirDate: '2021-10-19',
    originalName: 'nameTV',
    originalLanguage: 'id',
    voteAverage: 1,
    voteCount: 1,
    originCountry: [],
  );

  final tTVList = <TV>[tTV];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTVs.execute())
        .thenAnswer((_) async => Right(tTVList));
    // act
    notifier.fetchPopularTV();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularTVs.execute())
        .thenAnswer((_) async => Right(tTVList));
    // act
    await notifier.fetchPopularTV();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvList, tTVList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTVs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularTV();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
