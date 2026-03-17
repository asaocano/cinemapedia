import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Repositorio de solo lectura (inmutable)
/*
El provider entrega el repository ya configurado con el datasource concreto; 
la UI solo lo consume, sin preocuparse de cómo ni de dónde llegan los datos
 */
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImplementation(datasource: MoviedbDatasource());
});
