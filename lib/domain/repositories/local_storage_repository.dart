import 'package:cinemapedia/domain/entities/movie.dart';

/*
  Es el contrato que define qué métodos existen, y las implementaciones concretas usan 
  ese contrato para procesar, combinar y adaptar la información antes de entregarla al 
  dominio o a la UI.
*/
abstract class LocalStorageRepository {
  Future<void> toggleFavoriteMovie(Movie movie);
  Future<bool> isFavoriteMovie(int movieId);
  Future<List<Movie>> loadFavoriteMovies({int limit = 10, int offset = 0});
}