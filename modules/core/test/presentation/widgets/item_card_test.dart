import 'package:core/core.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:core/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/fake_cache_manager.dart';

void main() {
  late Movie movieData;
  late FakeCacheManager cacheManager;

  setUp(() {
    cacheManager = FakeCacheManager();
    movieData = Movie(
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
  });

  tearDown(() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: kColorScheme,
        primaryColor: kRichBlack,
        scaffoldBackgroundColor: kRichBlack,
        textTheme: kTextTheme,
      ),
      home: Scaffold(body: body),
    );
  }

  testWidgets('Check if ItemCard should show properly', (WidgetTester tester) async {
    final cardFinder = find.byType(Card);
    await tester.pumpWidget(_makeTestableWidget(ItemCard(
      movieData,
      isMovies: true,
      cacheManager: cacheManager,
    )));
    final textFinder = find.text('Spider-Man');
    expect(textFinder, findsOneWidget);
    expect(cardFinder, findsOneWidget);
  });

  testWidgets('Check if ItemCard on error should show error image', (WidgetTester tester) async {
    cacheManager.throwsNotFound('http://somerandomaddress.com');
    final cardFinder = find.byType(Card);
    await tester.pumpWidget(_makeTestableWidget(ItemCard(
      movieData,
      isMovies: true,
      cacheManager: cacheManager,
    )));
    await tester.pumpAndSettle();
    final textFinder = find.text('Spider-Man');
    final errorFinder = find.byType(Icon);
    final errorKeyFinder = find.byKey(Key('error_icon'));
    expect(textFinder, findsOneWidget);
    expect(cardFinder, findsOneWidget);
    expect(errorFinder, findsOneWidget);
    expect(errorKeyFinder, findsOneWidget);
  });
}
