import 'package:dartz/dartz.dart';
import 'package:tv_shows/domain/usecases/get_tv_episodes_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVEpisodesDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVEpisodesDetail(mockTVRepository);
  });

  final tId = 1;

  test('should get tv detail from the repository', () async {
    // arrange
    when(mockTVRepository.getTVEpisodesDetail(tId, tId, tId))
        .thenAnswer((_) async => Right(testTVEpisodesDetail));
    // act
    final result = await usecase.execute(tId, tId, tId);
    // assert
    expect(result, Right(testTVEpisodesDetail));
  });
}
