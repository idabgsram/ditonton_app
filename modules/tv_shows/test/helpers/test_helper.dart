import 'package:core/core.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:tv_shows/data/datasources/tv_local_data_source.dart';
import 'package:tv_shows/data/datasources/tv_remote_data_source.dart';
import 'package:tv_shows/domain/repositories/tv_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  TVRepository,
  TVRemoteDataSource,
  TVLocalDataSource,
  DatabaseHelper,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
])
void main() {}
