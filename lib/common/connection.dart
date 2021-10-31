import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class Connection {
  Future<SecurityContext> get _globalContext async {
    final sslCert = await rootBundle.load('assets/cert/tmdb.cer');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<Response> get(Uri uri) async {
    HttpClient client = HttpClient(context: await _globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(uri);
    return response;
  }
}
