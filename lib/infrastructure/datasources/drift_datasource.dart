import 'package:cinemapedia/config/database/database.dart';
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:drift/drift.dart' as drift;

/*
Es la representación real de los métodos definidos en domain, implementando 
cómo obtener y preparar los datos para que el dominio pueda usarlos sin 
preocuparse por el origen.
 */
class DriftDatasource extends LocalStorageDatasource {
  final AppDatabase database;

  //Constructor para asignar qué db se usará (si no se envía por constructor se usa drift por defecto)
  DriftDatasource([AppDatabase? databaseToUse])
    : database = databaseToUse ?? db;

  //Consulta si una película está marcada como favorita
  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    //Construir query
    final query = database.select(database.favoriteMovies)
      ..where((table) => table.movieId.equals(movieId));

    //Ejecutar query
    final favoriteMovie = await query.getSingleOrNull();

    //Retornar resultado
    return favoriteMovie != null;
  }

  //Consulta las películas guardadas localmente como favoritas
  @override
  Future<List<Movie>> loadFavoriteMovies({
    int limit = 10,
    int offset = 0,
  }) async {
    //Construcción de query
    final query = database.select(database.favoriteMovies)
      ..limit(limit, offset: offset);

    //Ejecución de query
    final favoriteMovieRows = await query.get();

    //Retorno de películas
    final movies = favoriteMovieRows
        .map(
          (row) => Movie(
            adult: false,
            backdropPath: row.backdropPath,
            genreIds: const [],
            id: row.movieId,
            originalLanguage: '',
            originalTitle: row.originalTitle,
            overview: '',
            popularity: 0,
            posterPath: row.posterPath,
            releaseDate: DateTime.now(),
            title: row.title,
            video: false,
            voteAverage: row.voteAverage,
            voteCount: 0,
          ),
        )
        .toList();

    return movies;
  }

  //Acción para marcar/desmarcar una película como favorita
  @override
  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await isFavoriteMovie(
      movie.id,
    ); //Revisa si la película existe en la bd

    //Si existe, significa que se debe desmarcar
    if (isFavorite) {
      //Se elimina la película de la bd
      final deleteQuery = database.delete(database.favoriteMovies)
        ..where((table) => table.movieId.equals(movie.id));

      await deleteQuery.go();
      return;
    }

    //Si no existe, se agrega a la bd
    await database
        .into(database.favoriteMovies)
        .insert(
          FavoriteMoviesCompanion.insert(
            movieId: movie.id,
            backdropPath: movie.backdropPath,
            originalTitle: movie.originalTitle,
            posterPath: movie.posterPath,
            title: movie.title,
            voteAverage: drift.Value(movie.voteAverage),
          ),
        );
  }
}
