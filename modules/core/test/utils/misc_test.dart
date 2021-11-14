import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_mock.dart';

void main() {
  setupFirebaseAnalyticsMocks();
  late FirebaseAnalyticsUtils fau;
  setUpAll(() async {
    await Firebase.initializeApp();
    fau = FirebaseAnalyticsUtils();
  });

  group('Firebase analytics tests', () {
    setUp(() async {
      methodCallLog.clear();
    });

    tearDown(methodCallLog.clear);
    test('Send Analytics tests', () async {
      await fau.logEvent(eventName: 'test');
    });

    group('Misc test', () {
      test('Check route observer tests', () async {
        expect(routeObserver, TypeMatcher<RouteObserver<ModalRoute>>());
      });
    });
  });
}
