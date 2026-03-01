import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  });

  //* Función que controlará los cambios de la query (texto) que ingrese el usuario
  void _onQueryChanged(String query) {
    isLoadingStream.add(true); //* Se agrega un nuevo estado de "cargando" (el estado se cambia a true) para mostrar el widget que gira
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel(); //* Si el usuario sigue escribiendo antes de que se cumplan los 500ms, se cancela el timer anterior para evitar lanzar una búsqueda innecesaria.

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async { //* Se da una ventana de 500 milisegundos sin que el usuario haya estado escribiendo para no buscar cada que el usuario presione una tecla y no consumir demasiados recursos del dispositivo
      final movies = await searchMovies(query); //* Ejecuta el callback que obtiene las películas (normalmente desde una API)
      debouncedMovies.add(movies); //* Agrega las películas al stream para que se muestren en la lista
      initialMovies = movies; //* Actualiza las películas iniciales para que el StreamBuilder tenga el último resultado como base si se reconstruye.
      isLoadingStream.add(false); //* Se termina la petición para que se quite el widget girando y se muestre el de borrar
    });
  }

  void clearStreams() {
    //* Cierra cualquier timer que no se haya terminado aún
    _debounceTimer?.cancel();
    debouncedMovies.close();
    isLoadingStream.close(); 
  }

  //* Texto que se mostrará en el buscador como ayuda al usuario para indicar qué debe hacer o ingresar 
  @override
  String? get searchFieldLabel => "Buscar película";

  //* Función que regresará la lista de widgets cuando se hace una búsqueda
  Widget buildResultsAndSuggestions() {
    return StreamBuilder( //* StreamBuilder para suscribirse a los cambios de la lista de películas
      initialData: initialMovies, //* Películas iniciales
      stream: debouncedMovies.stream, //* Se suscribe al stream (Los cambios a los que estará pendiente)
      builder: (context, snapshot) {
        final movies = snapshot.data ?? []; //* Si el stream aún no ha emitido nada, usa lista vacía.

        return ListView.builder( //* Construye una lista de widgets de tipo "MovieItem"
          itemCount: movies.length, //* ¿Cuántos items hay?
          itemBuilder: (context, index) { //* Construye la lista en base a la info regresada por el stream builder
            final movie = movies[index]; //* Película en la posición actual
            return _MovieItem(
              movie: movie,
              onMovieSelected: (context, movie) { //* Función que se ejecutará dentro del widget
                clearStreams();
                close(context, movie);
              },
            );
            // return ListTile(title: Text(movie.title));
          },
        );
      },
    );
  }

  //* Muestra acciones que tendrá la pantalla de búsqueda (¿Qué botones o widgets tendrá?)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder( //* Reconstruye la UI cada vez que el stream emite un nuevo valor.
        initialData: false, //* Valor inicial 
        stream: isLoadingStream.stream, //* Se suscribe al stream (Los cambios a los que estará pendiente)
        builder: (context, snapshot) {
          if (snapshot.data ?? false) { //* Último valor emitido (Si no hay un valor se usa uno por defecto)
          //* Si está cargando, muestra un widget girando indicando que se está "procesando" su búsqueda
            return SpinPerfect(
              infinite: true,
              spins: 200,
              duration: const Duration(seconds: 5),
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }

          //* Si no está cargando, se muestra botón para limpiar búsqueda
          return FadeIn(
            animate: query.isNotEmpty,
            duration: Duration(milliseconds: 200),
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  //* ¿Qué widgets tendrá ANTES de la barra de búsqueda? (Generalmente es el botón para regresar)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams(); //* Cierra los streams a los que está suscrito
        close(context, null); //* Ejecuta la función para cerrar búsqueda o regresar (Se manda null para que la pantalla anterior no haga nada)
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  //* Indica qué se hará al FINALIZAR la búsqueda (Cuando el usuario presione el botón "Aceptar" o el que permita completar la búsqueda)
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions(); //* Función que realiza la búsqueda
  }

  //* Indica qué se hará MIENTRAS se realiza la búsqueda (Mientras el usuario escribe)
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query); //* Reacciona al nuevo valor de la query (El texto de búsqueda) ejecutando el debounce 
    return buildResultsAndSuggestions(); //* Función que realiza la búsqueda
  }
}
/// Widget que representa una película en la lista de películas buscadas//
class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});
  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector( //* Widget que se usa para detectar gestos (un tap, en este caso) de forma que al interactuar con el widget hijo, haga determinada acción
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            //Image
            SizedBox(
              width: size.width * 0.2, //* Toma el 20% del ancho del dispositivo
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => //* Muestra un widget mientras la imagen se carga
                      FadeIn(child: child), //* Cuando se carga la imagen, se muestra una animación 
                ),
              ),
            ),
            SizedBox(width: 10),
            //Description
            SizedBox(
              width: size.width * 0.7, //* Toma el 70% del ancho del dispositivo
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //* Se alinea al inicio de la columna
                children: [
                  Text(movie.title, style: textStyles.titleMedium), //* Titulo de la película
                  (movie.overview.length > 100) //* Si el largo de la sinopsis es mayor a 100, se corta a 100 y se muestran puntos suspensivos para acortarla
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormat.scoreTransform(movie.voteAverage),
                        style: textStyles.bodySmall!.copyWith(
                          color: Colors.yellow.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
