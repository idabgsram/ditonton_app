// Copyright 2020 Rene Floor. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mocktail/mocktail.dart';

class FakeCacheManager extends Mock implements CacheManager {
  void throwsNotFound(String url) {
    when(() => getFileStream(
              url,
              key: any(named: 'key'),
              headers: any(named: 'headers'),
              withProgress: any(named: 'withProgress'),
            ))
        .thenThrow(HttpExceptionWithStatus(404, 'Invalid statusCode: 404',
            uri: Uri.parse(url)));
  }
}
