//Repositorio de solo lectura (inmutable)
/*
El provider entrega el repository ya configurado con el datasource concreto; 
la UI solo lo consume, sin preocuparse de cómo ni de dónde llegan los datos
 */
import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorRepositoryProvider = Provider((ref) {
  return ActorRepositoryImplementation(datasource: ActorMoviedbDatasource());
});
