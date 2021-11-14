import 'package:dartz/dartz.dart';
import 'package:tv_shows/domain/usecases/save_tv_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTVWatchlist usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SaveTVWatchlist(mockTVRepository);
  });

  test('should save tv to the repository', () async {
    // arrange
    when(mockTVRepository.saveTVWatchlist(testTVDetail))
        .thenAnswer((_) async => Right('Added to TV Watchlist'));
    // act
    final result = await usecase.execute(testTVDetail);
    // assert
    verify(mockTVRepository.saveTVWatchlist(testTVDetail));
    expect(result, Right('Added to TV Watchlist'));
  });
}
