import 'package:cinemapedia/domain/entities/actor.dart';

/*
  Es el contrato que define qué métodos existen, y las implementaciones concretas usan 
  ese contrato para procesar, combinar y adaptar la información antes de entregarla al 
  dominio o a la UI.
*/
abstract class ActorsRepository {
  Future<List<Actor>> getActorsByMovie(String movieId);
}
