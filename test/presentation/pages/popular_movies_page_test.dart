import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FakeEvent extends Fake implements PopularMoviesEvent {}

class FakeState extends Fake implements PopularMoviesState {}

class MockBlocProvider extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

void main() {
  late MockBlocProvider mockBloc;

  setUp(() {
    registerFallbackValue(FakeEvent());
    registerFallbackValue(FakeState());
    mockBloc = MockBlocProvider();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>(create: (c) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataAvailable([]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('List View should show item card', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataAvailable([
      Movie(
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
      )
    ]));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    final itemCardFinder = find.byType(ItemCard);

    expect(itemCardFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(DataError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
