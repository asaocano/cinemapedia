import 'package:cinemapedia/domain/entities/movie.dart';

/*
  Es el contrato que define qué métodos existen, y las implementaciones concretas usan 
  ese contrato para procesar, combinar y adaptar la información antes de entregarla al 
  dominio o a la UI.
*/
abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
}
