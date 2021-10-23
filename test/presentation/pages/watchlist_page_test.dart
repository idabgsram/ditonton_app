import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_page_test.mocks.dart';

@GenerateMocks([WatchlistMovieNotifier, WatchlistTVNotifier])
void main() {
  late MockWatchlistMovieNotifier mockNotifier;
  late MockWatchlistTVNotifier mockTVNotifier;

  setUp(() {
    mockNotifier = MockWatchlistMovieNotifier();
    mockTVNotifier = MockWatchlistTVNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistMovieNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  Widget _makeTVTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistTVNotifier>.value(
      value: mockTVNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

}
