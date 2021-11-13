import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../dummy_data/dummy_objects.dart';

class FakeEvent extends Fake implements TopRatedTVEvent {}

class FakeState extends Fake implements TopRatedTVState {}

class MockBlocProvider extends MockBloc<TopRatedTVEvent, TopRatedTVState>
    implements TopRatedTVBloc {}

void main() {
  late MockBlocProvider mockBloc;
  late Widget widgetToTest;

  setUp(() {
    registerFallbackValue(FakeEvent());
    registerFallbackValue(FakeState());
    mockBloc = MockBlocProvider();
    widgetToTest = TopRatedTVPage();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVBloc>(
      create: (c) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  Widget _makeAnotherTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVBloc>(create: (c) => mockBloc, child: body);
  }

  final routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => FakeHomePage(),
    TVDetailPage.ROUTE_NAME: (BuildContext context) => FakeTargetPage(),
    '/second': (BuildContext context) =>
        _makeAnotherTestableWidget(widgetToTest),
  };

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should go back when onBack tapped',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataAvailable([]));

    await tester.pumpWidget(MaterialApp(routes: routes));
    expect(find.byKey(Key('fake_tile')), findsOneWidget);

    await tester.tap(find.byKey(Key('fake_tile')));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(seconds: 1));

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
    expect(find.byKey(Key('fake_tile')), findsNothing);

    await tester.tap(find.byKey(Key('back_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(seconds: 1));
    expect(listViewFinder, findsNothing);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataAvailable([]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('List View should show item card', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataAvailable([testTV]));
    await tester.pumpWidget(_makeTestableWidget(widgetToTest));

    final itemCardFinder = find.byType(ItemCard);

    expect(itemCardFinder, findsOneWidget);
  });

  testWidgets('Tapping on itemCard should go to detail page',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataAvailable([testTV]));

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
  });
  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

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
}
