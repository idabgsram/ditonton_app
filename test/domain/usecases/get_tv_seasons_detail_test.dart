import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_seasons_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVSeasonsDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVSeasonsDetail(mockTVRepository);
  });

  final tId = 1;

  test('should get tv detail from the repository', () async {
    // arrange
    when(mockTVRepository.getTVSeasonsDetail(tId, tId))
        .thenAnswer((_) async => Right(testTVSeasonsDetail));
    // act
    final result = await usecase.execute(tId, tId);
    // assert
    expect(result, Right(testTVSeasonsDetail));
  });
}
