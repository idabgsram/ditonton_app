import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_page_test.mocks.dart';

@GenerateMocks([WatchlistNotifier])
void main() {
  late MockWatchlistNotifier mockNotifier;
  late Movie movieData;
  late TV tvData;

  setUp(() {
    mockNotifier = MockWatchlistNotifier();
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
      tvData=TV(
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
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

// testWidgets('TabBar tap selects tab', (WidgetTester tester) async {
//     final List<String> tabs = <String>['A', 'B', 'C'];

//     await tester.pumpWidget(buildFrame(tabs: tabs, value: 'C'));
//     expect(find.text('A'), findsOneWidget);
//     expect(find.text('B'), findsOneWidget);
//     expect(find.text('C'), findsOneWidget);
//     final TabController controller = DefaultTabController.of(tester.element(find.text('A')))!;
//     expect(controller, isNotNull);
//     expect(controller.index, 2);
//     expect(controller.previousIndex, 2);

//     await tester.pumpWidget(buildFrame(tabs: tabs, value: 'C'));
//     await tester.tap(find.text('B'));
//     await tester.pump();
//     expect(controller.indexIsChanging, true);
//     await tester.pump(const Duration(seconds: 1)); // finish the animation
//     expect(controller.index, 1);
//     expect(controller.previousIndex, 2);
//     expect(controller.indexIsChanging, false);

//     await tester.pumpWidget(buildFrame(tabs: tabs, value: 'C'));
//     await tester.tap(find.text('C'));
//     await tester.pump();
//     await tester.pump(const Duration(seconds: 1));
//     expect(controller.index, 2);
//     expect(controller.previousIndex, 1);

//     await tester.pumpWidget(buildFrame(tabs: tabs, value: 'C'));
//     await tester.tap(find.text('A'));
//     await tester.pump();
//     await tester.pump(const Duration(seconds: 1));
//     expect(controller.index, 0);
//     expect(controller.previousIndex, 2);
//   });
  testWidgets('Page should display tab on init',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Empty);
    when(mockNotifier.message).thenReturn('Initialized');

    final tabBarFinder = find.byType(TabBarView);

    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));

    expect(tabBarFinder, findsOneWidget);
  });

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));
    final TabController controller =
        DefaultTabController.of(tester.element(find.text('Movies')))!;
    expect(controller, isNotNull);
    expect(controller.index, 0);
    expect(centerFinder, findsWidgets);
    expect(progressBarFinder, findsOneWidget);

    await tester.tap(find.text('TV Shows'));
    await tester.pump();
    expect(controller.index, 1);
    expect(centerFinder, findsWidgets);
    expect(progressBarFinder, findsOneWidget);
  });
  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
    when(mockNotifier.watchlistTVs).thenReturn(<TV>[]);
    when(mockNotifier.watchlistMovies).thenReturn(<Movie>[]);

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

  testWidgets('Page should display Item Card when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
    when(mockNotifier.watchlistTVs).thenReturn(<TV>[
      tvData
    ]);
    when(mockNotifier.watchlistMovies).thenReturn(<Movie>[
      movieData
    ]);

    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));
    final TabController controller =
        DefaultTabController.of(tester.element(find.text('TV Shows')))!;
    expect(controller, isNotNull);
    expect(controller.index, 0);
    final itemCardFinder = find.byType(ItemCard);

    expect(itemCardFinder, findsOneWidget);

    await tester.tap(find.text('TV Shows'));
    await tester.pump();
    expect(controller.index, 1);

    expect(itemCardFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));
    final TabController controller =
        DefaultTabController.of(tester.element(find.text('Movies')))!;
    expect(controller, isNotNull);
    expect(controller.index, 0);
    expect(textFinder, findsOneWidget);

    await tester.tap(find.text('TV Shows'));
    await tester.pump();
    expect(controller.index, 1);
    expect(textFinder, findsOneWidget);
  });
}
