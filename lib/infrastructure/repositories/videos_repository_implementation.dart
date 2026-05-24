import 'package:cinemapedia/domain/datasources/videos_datasource.dart';
import 'package:cinemapedia/domain/repositories/videos_repository.dart';

class VideosRepositoryImplementation extends VideosRepository {
  final VideosDatasource datasource;

  VideosRepositoryImplementation({required this.datasource});

  @override
  Future<String> getTrailerIdByMovieId(String movieId) {
    return datasource.getTrailerIdByMovieId(movieId);
  }
}
