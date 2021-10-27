import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton/presentation/provider/ota_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ota_tv_notifier_test.mocks.dart';

@GenerateMocks([GetOnTheAirTV])
void main() {
  late MockGetOnTheAirTV mockGetOnTheAirTV;
  late OTATVNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnTheAirTV = MockGetOnTheAirTV();
    notifier = OTATVNotifier(mockGetOnTheAirTV)
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
    when(mockGetOnTheAirTV.execute()).thenAnswer((_) async => Right(tTVList));
    // act
    notifier.fetchOTATV();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv data when data is gotten successfully', () async {
    // arrange
    when(mockGetOnTheAirTV.execute()).thenAnswer((_) async => Right(tTVList));
    // act
    await notifier.fetchOTATV();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvList, tTVList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetOnTheAirTV.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchOTATV();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
