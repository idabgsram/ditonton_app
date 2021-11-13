import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeMovieEvent extends Fake implements WatchlistMoviesEvent {}

class FakeTVEvent extends Fake implements WatchlistTVEvent {}

class FakeMovieState extends Fake implements WatchlistMoviesState {}

class FakeTVState extends Fake implements WatchlistTVState {}

class MockBlocProvider
    extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState>
    implements WatchlistMoviesBloc {}

class MockBlocTVProvider extends MockBloc<WatchlistTVEvent, WatchlistTVState>
    implements WatchlistTVBloc {}

void main() {
  late MockBlocProvider movieBloc;
  late MockBlocTVProvider tvBloc;
  late Movie movieData;
  late TV tvData;
  late Widget widgetToTest;

  setUp(() {
    registerFallbackValue(FakeMovieEvent());
    registerFallbackValue(FakeMovieState());
    registerFallbackValue(FakeTVEvent());
    registerFallbackValue(FakeTVState());
    movieBloc = MockBlocProvider();
    tvBloc = MockBlocTVProvider();
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
    tvData = TV(
      backdropPath: '/4QNBIgt5fwgNCN3OSU6BTFv0NGR.jpg',
      genreIds: [16, 10759],
      id: 888,
      name: 'Spider-Man',
      overview:
          'Bitten by a radioactive spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.',
      popularity: 82.967,
      posterPath: '/wXthtEN5kdWA1bHz03lkuCJS6hA.jpg',
      firstAirDate: '1994-11-19',
      originalName: 'Spider-Man',
      originalLanguage: "en",
      voteAverage: 8.3,
      voteCount: 633,
      originCountry: ["US"],
    );
    widgetToTest = WatchlistPage();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WatchlistMoviesBloc>(
          create: (c) => movieBloc,
        ),
        BlocProvider<WatchlistTVBloc>(
          create: (c) => tvBloc,
        )
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  Widget _makeAnotherTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WatchlistMoviesBloc>(
          create: (c) => movieBloc,
        ),
        BlocProvider<WatchlistTVBloc>(
          create: (c) => tvBloc,
        )
      ],
      child: body,
    );
  }

  final routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => FakeHomePage(),
    MovieDetailPage.ROUTE_NAME: (BuildContext context) => FakeTargetPage(),
    TVDetailPage.ROUTE_NAME: (BuildContext context) => FakeTargetPage(),
    '/second': (BuildContext context) =>
        _makeAnotherTestableWidget(widgetToTest),
  };

  testWidgets('Page should display tab on init', (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataEmpty());
    when(() => tvBloc.state).thenReturn(DataTVEmpty());

    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));

    final TabController controller =
        DefaultTabController.of(tester.element(find.text('Movies')))!;
    final tabBarFinder = find.byType(TabBarView);
    final tabBarItemFinder = find.byType(Tab);

    expect(controller, isNotNull);
    expect(tabBarFinder, findsOneWidget);
    expect(tabBarItemFinder, findsNWidgets(2));
  });

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataLoading());
    when(() => tvBloc.state).thenReturn(DataTVLoading());

    final loadingIndicatorFinder = find.byKey(Key('loading_indicator'));
    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));
    final TabController controller =
        DefaultTabController.of(tester.element(find.text('Movies')))!;
    expect(controller, isNotNull);
    expect(controller.index, 0);
    expect(loadingIndicatorFinder, findsOneWidget);

    await tester.tap(find.text('TV Shows'));
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }
    final loadingIndicatorTVFinder = find.byKey(Key('loading_tv_indicator'));
    expect(controller.index, 1);
    expect(loadingIndicatorTVFinder, findsOneWidget);
  });
  testWidgets('Check for consumer', (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataAvailable([]));
    when(() => tvBloc.state).thenReturn(DataTVAvailable([]));

    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));

    final movieConsumerFinder = find.byKey(Key('bloc_movies'));

    expect(movieConsumerFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataAvailable([movieData]));
    when(() => tvBloc.state).thenReturn(DataTVAvailable([tvData]));

    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));
    final TabController controller =
        DefaultTabController.of(tester.element(find.text('TV Shows')))!;
    expect(controller, isNotNull);
    expect(controller.index, 0);

    final listViewFinder = find.byType(ListView);

    expect(listViewFinder, findsOneWidget);

    await tester.tap(find.text('TV Shows'));
    await tester.pump();
    expect(controller.index, 1);

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Check for TV consumer', (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataAvailable([]));
    when(() => tvBloc.state).thenReturn(DataTVAvailable([]));

    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));
    final TabController controller =
        DefaultTabController.of(tester.element(find.text('TV Shows')))!;
    controller.index = 1;
    await tester.pumpAndSettle();

    final tvConsumerFinder = find.byKey(Key('bloc_tv'));

    expect(tvConsumerFinder, findsOneWidget);
  });

  testWidgets('Page should display Item Card when data is loaded',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataAvailable([movieData]));
    when(() => tvBloc.state).thenReturn(DataTVAvailable([tvData]));

    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));
    final TabController controller =
        DefaultTabController.of(tester.element(find.text('TV Shows')))!;
    expect(controller, isNotNull);
    expect(controller.index, 0);
    final itemCardFinder = find.byType(ItemCard);

    expect(itemCardFinder, findsOneWidget);

    await tester.tap(find.text('TV Shows'));
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }
    expect(controller.index, 1);

    expect(itemCardFinder, findsOneWidget);
  });

  testWidgets('Tapping on itemCard should go to detail page',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataAvailable([movieData]));
    when(() => tvBloc.state).thenReturn(DataTVAvailable([tvData]));

    await tester.pumpWidget(MaterialApp(
      routes: routes,
    ));

    expect(find.byKey(Key('fake_tile')), findsOneWidget);

    await tester.tap(find.byKey(Key('fake_tile')));
    for (int i = 0; i < 3; i++) {
      await tester.pump(Duration(seconds: 1));
    }

    final itemCardFinder = find.byType(ItemCard);
    expect(itemCardFinder, findsOneWidget);
    expect(find.byKey(Key('fake_tile')), findsNothing);

    await tester.tap(find.byKey(Key('item_0')));
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }
    expect(itemCardFinder, findsNothing);
    expect(find.byKey(Key('fake_second_tile')), findsOneWidget);
    
    await tester.tap(find.byKey(Key('fake_second_tile')));
    for (int i = 0; i < 3; i++) {
      await tester.pump(Duration(seconds: 1));
    }
    final itemNewCardFinder = find.byType(ItemCard);
    expect(itemNewCardFinder, findsOneWidget);
  });

  testWidgets('Tapping on tv itemCard should go to tv detail page',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataAvailable([movieData]));
    when(() => tvBloc.state).thenReturn(DataTVAvailable([tvData]));

    await tester.pumpWidget(MaterialApp(
      routes: routes,
    ));

    expect(find.byKey(Key('fake_tile')), findsOneWidget);

    await tester.tap(find.byKey(Key('fake_tile')));
    for (int i = 0; i < 3; i++) {
      await tester.pump(Duration(seconds: 1));
    }
    final TabController controller =
        DefaultTabController.of(tester.element(find.text('Movies')))!;
    expect(controller, isNotNull);
    expect(controller.index, 0);
    final itemCardFinder = find.byKey(Key('item_0'));
    expect(itemCardFinder, findsOneWidget);

    await tester.tap(find.text('TV Shows'));
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }
    final tvItemCardFinder = find.byKey(Key('item_tv_0'));
    expect(tvItemCardFinder, findsOneWidget);
    expect(find.byKey(Key('fake_tile')), findsNothing);

    await tester.tap(find.byKey(Key('item_tv_0')));
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }
    expect(itemCardFinder, findsNothing);
  });

  testWidgets('Page should display Text when no data is loaded',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataAvailable([]));
    when(() => tvBloc.state).thenReturn(DataTVAvailable([]));

    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));
    final TabController controller =
        DefaultTabController.of(tester.element(find.text('Movies')))!;
    expect(controller, isNotNull);
    expect(controller.index, 0);
    final emptyTextFinder = find.byKey(Key('empty_list'));
    expect(emptyTextFinder, findsOneWidget);

    await tester.tap(find.text('TV Shows'));
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }
    final emptyTextTVFinder = find.byKey(Key('empty_tv_list'));
    expect(controller.index, 1);
    expect(emptyTextTVFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataError(''));
    when(() => tvBloc.state).thenReturn(DataTVError(''));

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));
    final TabController controller =
        DefaultTabController.of(tester.element(find.text('Movies')))!;
    expect(controller, isNotNull);
    expect(controller.index, 0);
    final errorTextFinder = find.byKey(Key('error_message'));
    expect(errorTextFinder, findsOneWidget);

    await tester.tap(find.text('TV Shows'));
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }
    final errorTextTVFinder = find.byKey(Key('error_tv_message'));
    expect(controller.index, 1);
    expect(errorTextTVFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Empty',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataEmpty());
    when(() => tvBloc.state).thenReturn(DataTVEmpty());

    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));
    final TabController controller =
        DefaultTabController.of(tester.element(find.text('Movies')))!;
    expect(controller, isNotNull);
    expect(controller.index, 0);
    final emptyTextFinder = find.byKey(Key('empty_image'));
    expect(emptyTextFinder, findsOneWidget);

    await tester.tap(find.text('TV Shows'));
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }
    final emptyTextTVFinder = find.byKey(Key('empty_tv_image'));
    expect(controller.index, 1);
    expect(emptyTextTVFinder, findsOneWidget);
  });

  testWidgets('Page should go back when onBack tapped',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(DataAvailable([]));
    when(() => tvBloc.state).thenReturn(DataTVAvailable([]));

    await tester.pumpWidget(MaterialApp(routes: routes));
    expect(find.byKey(Key('fake_tile')), findsOneWidget);

    await tester.tap(find.byKey(Key('fake_tile')));

    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }

    final tabBarViewFinder = find.byType(TabBarView);
    expect(tabBarViewFinder, findsOneWidget);
    expect(find.byKey(Key('fake_tile')), findsNothing);

    await tester.tap(find.byKey(Key('back_button')));
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 10));
    }
    expect(tabBarViewFinder, findsNothing);
  });
}
