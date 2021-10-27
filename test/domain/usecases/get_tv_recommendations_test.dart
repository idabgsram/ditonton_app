import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVRecommendations usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVRecommendations(mockTVRepository);
  });

  final tId = 1;
  final tTVs = <TV>[];

  test('should get list of tv recommendations from the repository', () async {
    // arrange
    when(mockTVRepository.getTVRecommendations(tId))
        .thenAnswer((_) async => Right(tTVs));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTVs));
  });
}
