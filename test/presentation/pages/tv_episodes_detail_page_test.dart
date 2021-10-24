import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_episodes_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_episodes_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_episodes_detail_page_test.mocks.dart';

@GenerateMocks([TVEpisodesDetailNotifier])
void main() {
  late MockTVEpisodesDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVEpisodesDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVEpisodesDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tId = 1;

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.tvEpisodesState).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TVEpisodesDetailPage(
      id: tId,
      seasonNumber: tId,
      epsNumber: tId,
    )));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Check for TV detail Container', (WidgetTester tester) async {
    when(mockNotifier.tvEpisodesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvEpisodesData).thenReturn(testTVEpisodesDetail);

    final imageView = find.byType(CachedNetworkImage);
    final scrollSheetView = find.byType(DraggableScrollableSheet);

    await tester.pumpWidget(_makeTestableWidget(TVEpisodesDetailPage(
      id: tId,
      seasonNumber: tId,
      epsNumber: tId,
    )));

    expect(imageView, findsWidgets);
    expect(scrollSheetView, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.tvEpisodesState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('provider_message'));

    await tester.pumpWidget(_makeTestableWidget(TVEpisodesDetailPage(
      id: tId,
      seasonNumber: tId,
      epsNumber: tId,
    )));

    expect(textFinder, findsOneWidget);
  });
}
