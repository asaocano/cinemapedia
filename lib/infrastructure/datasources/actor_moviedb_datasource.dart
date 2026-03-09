import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_cresponse.dart';
import 'package:dio/dio.dart';

/*
Es la representación real de los métodos definidos en domain, implementando 
cómo obtener y preparar los datos para que el dominio pueda usarlos sin 
preocuparse por el origen.
 */
class ActorMoviedbDatasource extends ActorsDatasource {
  //Instancia base para realizar peticiones
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.movieDbKey, 'language': 'es-MX'},
    ),
  );

//Se sobreescribe el método del datasource para obtener los actores de una película
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    final castResponse = CreditsResponse.fromJson(response.data);
    List<Actor> actors = castResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();

    return actors;
  }
}
