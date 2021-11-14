import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int i = 0;
  test('Doing a dummy test :)', () async {
    i = i + 1;
    expect(i, 1);
  });
}
