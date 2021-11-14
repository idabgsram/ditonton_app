import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';

void main() {
  group('SSL Pinning test', () {
    test('Make sure init works properly', () async {
      await Connection.initClient();
      expect(Connection.client, TypeMatcher<IOClient>());
    });

    test('Make sure Network info detect properly', () async {
      NetworkInfoImpl nii = NetworkInfoImpl(DataConnectionChecker());
      bool? connectionStatus = await nii.isConnected;
      expect(connectionStatus, isNotNull);
    });

    test('Checking if current SSL is valid', () async {
      final _client = await Connection.getClient;
      final response =
          await _client.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'));
      _client.close();
      expect(response.statusCode, 200);
    });
    test('Make sure access denied on invalid address', () async {
      final _client = await Connection.getClient;
      bool failed = false;
      try {
        await _client.get(Uri.parse('https://www.google.com'));
        _client.close();
      } catch (ex) {
        expect(ex, TypeMatcher<HandshakeException>());
        return;
      }
      failed = true;
      expect(failed, false);
    });
  });
}
