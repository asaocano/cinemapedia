import 'package:cinemapedia/domain/entities/movie.dart';

/*
  Clase que define cómo se obtiene la data.
  Es la abstracción que define qué operaciones existen para obtener datos en el dominio, 
  obligando a que cualquier implementación cumpla ese contrato, sin importar el origen de la información.
*/
abstract class LocalStorageDatasource {
  Future<void> toggleFavoriteMovie(Movie movie);
  Future<bool> isFavoriteMovie(int movieId);
  Future<List<Movie>> loadFavoriteMovies({int limit = 10, int offset = 0});
}
