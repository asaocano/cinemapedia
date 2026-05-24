import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/videos_datasource.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/trailer_response.dart';
import 'package:dio/dio.dart';

class VideosMoviedbDatasource extends VideosDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.moviedbLink,
      queryParameters: {'api_key': Environment.movieDbKey},
    ),
  );

  @override
  Future<String> getTrailerIdByMovieId(String movieId) async {
    final response = await dio.get(
      '/movie/$movieId/videos',
      queryParameters: {'language': 'es-MX'},
    );

    final trailerResponse = TrailerResponse.fromJson(response.data);

    if (trailerResponse.results.isEmpty) {
      return "";
    }

    final trailers = trailerResponse.results;

    return trailers[0].key;
  }
}
