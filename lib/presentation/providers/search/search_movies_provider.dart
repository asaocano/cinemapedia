import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final searchQueryProvider = StateProvider<String>((ref) => ''); //* Guarda el string de la búsqueda que el usuario realizó (El valor inicial es un string vacío)
//El stateprovider se usa para valores simples como un string o un número o para estados simple sin lógica compleja asociada.

final searchedMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) { //* StateNotifierProvider se usa para casos más complejos que simplemente guardar un valor
      final movieRepository = ref.read(movieRepositoryProvider); //* Se inyecta el repositorio  de TheMovieDB
      return SearchMoviesNotifier(
        searchMovies: movieRepository.searchMovies,
        ref: ref,
      );
    }); //* Expone una lista reactiva de películas.

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

//*Manejador de estado del provider, se encarga de notificar a los listeners cuando se hace un cambio en el state
class SearchMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchMoviesCallback searchMovies;
  final Ref ref;

  SearchMoviesNotifier({required this.searchMovies, required this.ref})
    : super([]); //* El estado inicial es un arreglo vacío

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query); //* Ejecuta el callback que se envía en el constructor para buscar las películas
    ref.read(searchQueryProvider.notifier).update((state) => query); //* Actualiza el query para mostrarlo nuevamente si se necesita

    state = movies; //* Actualiza el estado con las películas obtenidas. De forma que se actualicen los listeners
    return movies; //* Regresa las películas para usarlas en el delegate de la búsqueda
  }
}
