import 'package:cinemapedia/domain/entities/actor.dart';

/*
  Clase que define cómo se obtiene la data.
  Es la abstracción que define qué operaciones existen para obtener datos en el dominio, 
  obligando a que cualquier implementación cumpla ese contrato, sin importar el origen de la información.
*/
abstract class ActorsDatasource {
  Future<List<Actor>> getActorsByMovie(String movieId);
}
