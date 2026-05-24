import 'package:cinemapedia/infrastructure/datasources/videos_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/videos_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trailerRepositoryProvider = Provider((ref) {
  return VideosRepositoryImplementation(datasource: VideosMoviedbDatasource());
});
