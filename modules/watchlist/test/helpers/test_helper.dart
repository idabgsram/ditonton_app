
import 'package:movies/domain/repositories/movie_repository.dart';
import 'package:tv_shows/domain/repositories/tv_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  TVRepository,
])
void main() {}
