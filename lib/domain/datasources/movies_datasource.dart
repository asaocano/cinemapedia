import 'package:cinemapedia/domain/entities/movie.dart';

/*
  Clase que define cómo se obtiene la data.
  Es la abstracción que define qué operaciones existen para obtener datos en el dominio, 
  obligando a que cualquier implementación cumpla ese contrato, sin importar el origen de la información.
*/
abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
  
}
