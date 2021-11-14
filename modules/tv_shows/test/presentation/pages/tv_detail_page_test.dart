import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:tv_shows/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv_shows/presentation/bloc/tv_detail_recommendations_bloc.dart';
import 'package:tv_shows/presentation/bloc/tv_detail_watchlist_bloc.dart';
import 'package:tv_shows/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../utils/fake_cache_manager.dart';

class FakeDetailEvent extends Fake implements TVDetailEvent {}

class FakeRecommendationsEvent extends Fake
    implements TVDetailRecommendationsEvent {}

class FakeWatchlistEvent extends Fake implements TVDetailWatchlistEvent {}

class FakeDetailState extends Fake implements TVDetailState {}

class FakeRecommendationsState extends Fake
    implements TVDetailRecommendationsState {}

class FakeWatchlistState extends Fake implements TVDetailWatchlistState {}

class MockBlocProvider extends MockBloc<TVDetailEvent, TVDetailState>
    implements TVDetailBloc {}

class MockRecommendationsBlocProvider
    extends MockBloc<TVDetailRecommendationsEvent, TVDetailRecommendationsState>
    implements TVDetailRecommendationsBloc {}

class MockWatchlistBlocProvider
    extends MockBloc<TVDetailWatchlistEvent, TVDetailWatchlistState>
    implements TVDetailWatchlistBloc {}

void main() {
  late MockBlocProvider detailBloc;
  late MockRecommendationsBlocProvider recommendationsBloc;
  late MockWatchlistBlocProvider watchlistBloc;
  late Widget widgetToTest;
  late FakeCacheManager cacheManager;

  final tId = 1;

  setUp(() {
    registerFallbackValue(FakeDetailEvent());
    registerFallbackValue(FakeRecommendationsEvent());
    registerFallbackValue(FakeWatchlistEvent());
    registerFallbackValue(FakeDetailState());
    registerFallbackValue(FakeRecommendationsState());
    registerFallbackValue(FakeWatchlistState());
    detailBloc = MockBlocProvider();
    recommendationsBloc = MockRecommendationsBlocProvider();
    watchlistBloc = MockWatchlistBlocProvider();
    cacheManager = FakeCacheManager();
    widgetToTest = TVDetailPage(id: tId, cacheManager: cacheManager);
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TVDetailBloc>(create: (c) => detailBloc),
        BlocProvider<TVDetailRecommendationsBloc>(
            create: (c) => recommendationsBloc),
        BlocProvider<TVDetailWatchlistBloc>(create: (c) => watchlistBloc)
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  Widget _makeAnotherTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TVDetailBloc>(create: (c) => detailBloc),
        BlocProvider<TVDetailRecommendationsBloc>(
            create: (c) => recommendationsBloc),
        BlocProvider<TVDetailWatchlistBloc>(create: (c) => watchlistBloc)
      ],
      child: body,
    );
  }

  final routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => FakeHomePage(),
    TV_SEASONS_DETAIL_ROUTE: (BuildContext context) => FakeTargetPage(),
    TV_DETAIL_ROUTE: (BuildContext context) => FakeTargetPage(),
    '/second': (BuildContext context) =>
        _makeAnotherTestableWidget(widgetToTest),
  };

  testWidgets('Detail should show loading first', (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataLoading());
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsEmpty());
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    final centerFinder = find.byType(Center);
    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should go back when onBack tapped',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetail));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([]));
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

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

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetail));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([]));
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when tv is added to wathclist',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetail));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([]));
    when(() => watchlistBloc.state).thenReturn(StatusReceived(true, ''));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetail));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([]));
    whenListen(
      watchlistBloc,
      Stream.fromIterable([
        StatusReceived(false, ''),
        StatusLoading(),
        StatusReceived(true, TVDetailWatchlistBloc.watchlistAddSuccessMessage)
      ]),
      initialState: StatusReceived(false, ''),
    );

    expect(watchlistBloc.state, StatusReceived(false, ''));

    final watchlistButton = find.byKey(Key('watchlist_btn'));

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);

    await tester.pump();
    verify(() => watchlistBloc.add(AddWatchlist(testTVDetail))).called(1);
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    expect(watchlistBloc.state,
        StatusReceived(true, TVDetailWatchlistBloc.watchlistAddSuccessMessage));
    expect(find.text(TVDetailWatchlistBloc.watchlistAddSuccessMessage),
        findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when removed from watchlist',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetail));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([]));
    whenListen(
      watchlistBloc,
      Stream.fromIterable([
        StatusReceived(true, ''),
        StatusLoading(),
        StatusReceived(
            false, TVDetailWatchlistBloc.watchlistRemoveSuccessMessage)
      ]),
      initialState: StatusReceived(true, ''),
    );

    expect(watchlistBloc.state, StatusReceived(true, ''));

    final watchlistButton = find.byKey(Key('watchlist_btn'));

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);

    await tester.pump();
    verify(() => watchlistBloc.add(RemoveFromWatchlist(testTVDetail)))
        .called(1);
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    expect(
        watchlistBloc.state,
        StatusReceived(
            false, TVDetailWatchlistBloc.watchlistRemoveSuccessMessage));
    expect(find.text(TVDetailWatchlistBloc.watchlistRemoveSuccessMessage),
        findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when watchlist status is Error',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetail));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([]));
    whenListen(
      watchlistBloc,
      Stream.fromIterable([
        StatusReceived(false, ''),
        StatusLoading(),
        StatusError('Database Failure')
      ]),
      initialState: StatusReceived(false, ''),
    );

    expect(watchlistBloc.state, StatusReceived(false, ''));

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.byIcon(Icons.check), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(watchlistBloc.state, StatusError('Database Failure'));
  });

  testWidgets(
      'Recommendation should display loading first when its come to load',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetail));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsLoading());
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    final centerFinder = find.byKey(Key('recommendations_center'));
    final progressBarFinder = find.byKey(Key('recommendations_loading'));

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });
  testWidgets('Recommendation shows when exists', (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetail));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([testTV]));
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(listViewFinder, findsNWidgets(2));
  });

  testWidgets(
      'Tapping on recommendation itemCard should go to another tv detail page',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetail));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([testTV]));
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    await tester.pumpWidget(MaterialApp(
      routes: routes,
    ));

    expect(find.byKey(Key('fake_tile')), findsOneWidget);

    await tester.tap(find.byKey(Key('fake_tile')));
    for (int i = 0; i < 3; i++) {
      await tester.pump(Duration(seconds: 1));
    }

    final recomItemFinder = find.byKey(Key('recom_item_0'));
    expect(recomItemFinder, findsOneWidget);
    expect(find.byKey(Key('fake_tile')), findsNothing);
    await tester.dragUntilVisible(
      recomItemFinder, // what you want to find
      find.byType(SingleChildScrollView), // widget you want to scroll
      const Offset(0, 50), // delta to move
    );
    await tester.tap(find.byKey(Key('recom_item_0')));
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }
    expect(recomItemFinder, findsNothing);
  });

  testWidgets('Recommendation should show no recommendation when exist',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetail));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([]));
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    final listViewFinder = find.byType(ListView);
    final noRecommendationText =
        find.text('No similar recommendation currently');

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(listViewFinder, findsOneWidget);
    expect(noRecommendationText, findsOneWidget);
  });
  testWidgets('Recommendations should display text with message when Error',
      (WidgetTester tester) async {
    when(() => detailBloc.state)
        .thenReturn(DataAvailable(testTVDetailAlternative));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsError('Error message'));
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    final textFinder = find.byKey(Key('recommendation_message'));

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(textFinder, findsOneWidget);
  });


  testWidgets(
      'Tapping on seasons item should go to tv seasons detail page',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetailCorrectImage));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([testTV]));
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    await tester.pumpWidget(MaterialApp(
      routes: routes,
    ));

    expect(find.byKey(Key('fake_tile')), findsOneWidget);

    await tester.tap(find.byKey(Key('fake_tile')));
    for (int i = 0; i < 3; i++) {
      await tester.pump(Duration(seconds: 1));
    }

    final seasonsItemFinder = find.byKey(Key('seasons_item_0'));
    expect(seasonsItemFinder, findsOneWidget);
    expect(find.byKey(Key('fake_tile')), findsNothing);
    await tester.dragUntilVisible(
      seasonsItemFinder,
      find.byType(SingleChildScrollView), 
      const Offset(0, 50),
    );
    await tester.tap(find.byKey(Key('seasons_item_0')));
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataError('Error message'));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsEmpty());
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    final textFinder = find.byKey(Key('provider_message'));

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Empty',
      (WidgetTester tester) async {
    when(() => detailBloc.state).thenReturn(DataEmpty());
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsEmpty());
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    final textFinder = find.text('Empty');

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(textFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display empty container when state recommendation is empty',
      (WidgetTester tester) async {
    when(() => detailBloc.state)
        .thenReturn(DataAvailable(testTVDetailAlternative));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsEmpty());
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    final containerFinder = find.byKey(Key('empty_recom'));

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(containerFinder, findsOneWidget);
  });

  testWidgets('Page should handle for null recommendation posterPath',
      (WidgetTester tester) async {
    when(() => detailBloc.state)
        .thenReturn(DataAvailable(testTVDetailAlternative));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([testTVAlternative]));
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    final boxFinder = find.byKey(Key('recommendations_lv'));
    await tester.pump();
    await tester.pump();
    await tester.pump();
    final box2Finder = find.byKey(Key('recom_item_0'));

    expect(boxFinder, findsOneWidget);
    expect(box2Finder, findsNothing);
  });

  testWidgets('Check if Image on error should show error image',
      (WidgetTester tester) async {
    cacheManager.throwsNotFound('http://somerandomaddress.com');
    when(() => detailBloc.state).thenReturn(DataAvailable(testTVDetail));
    when(() => recommendationsBloc.state)
        .thenReturn(DataRecommendationsAvailable([testTV]));
    when(() => watchlistBloc.state).thenReturn(StatusReceived(false, ''));
    await tester.pumpWidget(_makeTestableWidget(widgetToTest));
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }
    final cniFinder = find.byKey(Key('cached_image_poster'));
    final errorKeyFinder = find.byKey(Key('cached_image_poster_error'));
    final cniRecomFinder = find.byKey(Key('cached_image_recom_0'));
    final errorRecomKeyFinder = find.byKey(Key('cached_image_recom_error_0'));
    final cniSeasonsFinder = find.byKey(Key('cached_image_seasons_item_0'));
    final errorSeasonsKeyFinder =
        find.byKey(Key('cached_image_seasons_error_0'));
    expect(cniFinder, findsWidgets);
    expect(errorKeyFinder, findsWidgets);
    expect(cniRecomFinder, findsWidgets);
    expect(errorRecomKeyFinder, findsWidgets);
    expect(cniSeasonsFinder, findsWidgets);
    expect(errorSeasonsKeyFinder, findsWidgets);
  });
}
