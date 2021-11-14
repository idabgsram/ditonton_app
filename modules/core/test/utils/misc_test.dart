import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Misc test', () {
    test('Check route observer tests', () async {
      expect(routeObserver, TypeMatcher<RouteObserver<ModalRoute>>());
    });
  });
}
