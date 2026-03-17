import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/stores/local_storage_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

//Administrador del estado de las películas favoritas que están guardadas en almacenamiento local
final favoriteMoviesProvider = StateNotifierProvider((ref) {
  final localStorageRepository = ref.watch(
    localStorageRepositoryProvider,
  ); // Se obteniene el repositorio de almacenamiento local
  return StorageMoviesNotifier(
    localStorageRepository: localStorageRepository,
  ); //Se crea el notifier que manejará el estado
});

//Clase del notifier. Se maneja de modo (id: película => 54: Sueño de fuga)
class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0; //Página actual de las películas obtenidas de bd
  final LocalStorageRepository
  localStorageRepository; //Repositorio que se usará para realizar las acciones en bd

  StorageMoviesNotifier({required this.localStorageRepository})
    : super({}); //Constructor de la clase

  //Método para cargar más películas de la bd (Se cargan de 10 en 10)
  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadFavoriteMovies(
      limit: 10, //Solo se trae 10 películas
      offset:
          page *
          10, //Delimita cuántas películas se saltará para traer las siguientes 10
    ); //Obtiene las siguientes 10 películas basado en la página actual

    page++; //Se incrementa la página para la siguiente consulta

    final tempMovies =
        <int, Movie>{}; //Se crea una lista temporal para las películas nuevas

    for (final movie in movies) {
      // state = {...state, movie.id: movie};
      tempMovies[movie.id] = movie; //Se agrega la película obtenida a la lista
    }

    //Se actualiza el estado de las películas concatenando la lista temporal, de forma que se dispare el evento
    // para los widgets que escuchan se actualicen
    state = {...state, ...tempMovies};

    return movies;
  }

//Método para agregar/eliminar una película de la bd
  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await localStorageRepository.isFavoriteMovie(movie.id); //Se revisa si la película está en bd
    await localStorageRepository.toggleFavoriteMovie(movie); //Se agrega o elimina la película de la bd (dependiendo del estado actual)

    //Si estaba en bd, se elimina de la lista del provider
    if (isFavorite) {
      final newState = {...state}; //Se hace una copia
      newState.remove(movie.id); //Se elimina de la copia
      state = newState; //Se actualiza el estado con una nueva referencia para que se dispare el evento y los widgets se actualicen
      return;
    }

    state = {...state, movie.id: movie}; //Si no está, se actualiza la referencia agregando una nueva película
  }
}
