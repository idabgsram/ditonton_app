import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:tv_shows/presentation/bloc/tv_seasons_detail_bloc.dart';
import 'package:tv_shows/presentation/pages/tv_seasons_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../utils/fake_cache_manager.dart';

class FakeEvent extends Fake implements TVSeasonsDetailEvent {}

class FakeState extends Fake implements TVSeasonsDetailState {}

class MockBlocProvider
    extends MockBloc<TVSeasonsDetailEvent, TVSeasonsDetailState>
    implements TVSeasonsDetailBloc {}

void main() {
  late MockBlocProvider mockBloc;
  late Widget widgetToTest;
  late FakeCacheManager cacheManager;

  final tId = 1;

  setUp(() {
    registerFallbackValue(FakeEvent());
    registerFallbackValue(FakeState());
    cacheManager = FakeCacheManager();
    mockBloc = MockBlocProvider();
    widgetToTest = TVSeasonsDetailPage(
        id: tId, seasonNumber: tId, cacheManager: cacheManager);
  });

  tearDown(() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TVSeasonsDetailBloc>(
      create: (c) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  Widget _makeAnotherTestableWidget(Widget body) {
    return BlocProvider<TVSeasonsDetailBloc>(
        create: (c) => mockBloc, child: body);
  }

  final routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => FakeHomePage(),
    TV_EPISODES_DETAIL_ROUTE: (BuildContext context) => FakeTargetPage(),
    '/second': (BuildContext context) =>
        _makeAnotherTestableWidget(widgetToTest),
  };

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Check for TV detail Container', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataAvailable(testTVSeasonsDetailWithImage));

    final imageView = find.byType(CachedNetworkImage);
    final scrollSheetView = find.byType(DraggableScrollableSheet);

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(imageView, findsWidgets);
    expect(scrollSheetView, findsOneWidget);
  });

  testWidgets('Tapping on episodes itemCard should go to episodes detail page',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataAvailable(testTVSeasonsDetailWithImage));

    await tester.pumpWidget(MaterialApp(
      routes: routes,
    ));

    expect(find.byKey(Key('fake_tile')), findsOneWidget);

    await tester.tap(find.byKey(Key('fake_tile')));
    for (int i = 0; i < 3; i++) {
      await tester.pump(Duration(seconds: 1));
    }

    final episodesItemFinder = find.byKey(Key('episodes_item_tap'));
    expect(episodesItemFinder, findsOneWidget);
    expect(find.byKey(Key('fake_tile')), findsNothing);

    await tester.tap(find.byKey(Key('episodes_item_tap')));
  });

  testWidgets('Page should go back when onBack tapped',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataAvailable(testTVSeasonsDetailWithImage));

    await tester.pumpWidget(MaterialApp(routes: routes));
    expect(find.byKey(Key('fake_tile')), findsOneWidget);

    await tester.tap(find.byKey(Key('fake_tile')));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(seconds: 1));

    final dssFinder = find.byType(DraggableScrollableSheet);
    expect(dssFinder, findsOneWidget);
    expect(find.byKey(Key('fake_tile')), findsNothing);

    await tester.tap(find.byKey(Key('back_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(seconds: 1));
    expect(dssFinder, findsNothing);
  });


  testWidgets('Page should go back when onBack tapped on no Poster',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataAvailable(testTVSeasonsDetail));

    await tester.pumpWidget(MaterialApp(routes: routes));
    expect(find.byKey(Key('fake_tile')), findsOneWidget);

    await tester.tap(find.byKey(Key('fake_tile')));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(seconds: 1));

    final dssFinder = find.byType(DraggableScrollableSheet);
    expect(dssFinder, findsNothing);
    expect(find.byKey(Key('fake_tile')), findsNothing);

    final backButtonFinder = find.byKey(Key('back_button_no_poster'));
    await tester.tap(find.byKey(Key('back_button_no_poster')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(seconds: 1));
    expect(backButtonFinder, findsNothing);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataError('Error message'));

    final textFinder = find.byKey(Key('provider_message'));

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Empty',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataEmpty());

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    final textFinder = find.byKey(Key('empty_image'));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Check if Poster Image on error should show error image',
      (WidgetTester tester) async {
    cacheManager.throwsNotFound('http://somerandomaddress.com');
    when(() => mockBloc.state).thenReturn(DataAvailable(testTVSeasonsDetailWithImage));
    await tester.pumpWidget(_makeTestableWidget(widgetToTest));
    for (int i = 0; i < 3; i++) {
      await tester.pump(Duration(seconds: 1));
    }
    final cniFinder = find.byKey(Key('cached_image_poster'));
    final errorKeyFinder = find.byKey(Key('cached_image_poster_error'));
    final cniCrewFinder = find.byKey(Key('cached_image_episodes_135844'));
    final errorCrewKeyFinder = find.byKey(Key('cached_image_episodes_error_135844'));
    expect(cniFinder, findsWidgets);
    expect(errorKeyFinder, findsWidgets);
    expect(cniCrewFinder, findsWidgets);
    expect(errorCrewKeyFinder, findsWidgets);
  });
}
