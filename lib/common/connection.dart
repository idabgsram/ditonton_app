import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class Connection {
  static Future<SecurityContext> get _globalContext async {
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(utf8.encode(sslCertificate));
    return securityContext;
  }

  static Future<http.Client> get getClient async {
    HttpClient client = HttpClient(context: await _globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    return ioClient;
  }

  static Future<http.Client> get _instance async =>
      _clientInstance ??= await getClient;
  static http.Client? _clientInstance;

  static http.Client get client => _clientInstance ?? http.Client();

  static Future<void> initClient() async {
    _clientInstance = await _instance;
  }
}
