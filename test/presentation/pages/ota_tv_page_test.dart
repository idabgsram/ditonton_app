import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/ota_tv_page.dart';
import 'package:ditonton/presentation/provider/ota_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'ota_tv_page_test.mocks.dart';

@GenerateMocks([OTATVNotifier])
void main() {
  late MockOTATVNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockOTATVNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<OTATVNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(OTATVPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvList).thenReturn(<TV>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(OTATVPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('List View should show item card', (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvList).thenReturn(<TV>[
      TV(
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
      ),
    ]);

    await tester.pumpWidget(_makeTestableWidget(OTATVPage()));

    final itemCardFinder = find.byType(ItemCard);

    expect(itemCardFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(OTATVPage()));

    expect(textFinder, findsOneWidget);
  });
}
