import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/presentation/bloc/tv_episodes_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_episodes_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../utils/fake_cache_manager.dart';

class FakeEvent extends Fake implements TVEpisodesDetailEvent {}

class FakeState extends Fake implements TVEpisodesDetailState {}

class MockBlocProvider
    extends MockBloc<TVEpisodesDetailEvent, TVEpisodesDetailState>
    implements TVEpisodesDetailBloc {}

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
    widgetToTest = TVEpisodesDetailPage(
        id: tId, epsNumber: tId, seasonNumber: tId, cacheManager: cacheManager);
  });

  tearDown(() {
    PaintingBinding.instance?.imageCache?.clear();
    PaintingBinding.instance?.imageCache?.clearLiveImages();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TVEpisodesDetailBloc>(
      create: (c) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  Widget _makeAnotherTestableWidget(Widget body) {
    return BlocProvider<TVEpisodesDetailBloc>(
        create: (c) => mockBloc, child: body);
  }

  final routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => FakeHomePage(),
    TVDetailPage.ROUTE_NAME: (BuildContext context) => FakeTargetPage(),
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
    when(() => mockBloc.state).thenReturn(DataAvailable(testTVEpisodesDetail));

    final imageView = find.byType(CachedNetworkImage);
    final scrollSheetView = find.byType(DraggableScrollableSheet);

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(imageView, findsWidgets);
    expect(scrollSheetView, findsOneWidget);
  });

  testWidgets('Page should go back when onBack tapped',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataAvailable(testTVEpisodesDetail));

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
    when(() => mockBloc.state).thenReturn(DataAvailable(testTVEpisodesDetailNoPoster));

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
    when(() => mockBloc.state).thenReturn(DataAvailable(testTVEpisodesDetail));
    await tester.pumpWidget(_makeTestableWidget(widgetToTest));
    for (int i = 0; i < 3; i++) {
      await tester.pump(Duration(seconds: 1));
    }
    final cniFinder = find.byKey(Key('cached_image_poster'));
    final errorKeyFinder = find.byKey(Key('cached_image_poster_error'));
    final cniCrewFinder = find.byKey(Key('cached_image_crew'));
    final errorCrewKeyFinder = find.byKey(Key('cached_image_crew_error'));
    expect(cniFinder, findsWidgets);
    expect(errorKeyFinder, findsWidgets);
    expect(cniCrewFinder, findsWidgets);
    expect(errorCrewKeyFinder, findsWidgets);
  });
}
