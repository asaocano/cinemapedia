import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

/*
El repository es la capa intermedia que conecta los datasources con el dominio y la UI, 
asegurando que siempre se entreguen Entities listas 
y desacopladas de la fuente de datos
 */
class MovieRepositoryImplementation extends MoviesRepository {
  final MoviesDatasource datasource;

  MovieRepositoryImplementation({required this.datasource});
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }
}
