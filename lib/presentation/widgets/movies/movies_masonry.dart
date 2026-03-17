import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// StatefulWidget porque usa un ScrollController para detectar cuándo el usuario
// se acerca al final del scroll y cargar más películas (infinite scroll).
// El ScrollController necesita registrarse en initState() y liberarse en dispose().
class MoviesMasonry extends StatefulWidget {
  final List<Movie> movies; //Necesita recibir una lista de películas que mostrar
  final Future<List<Movie>> Function()? loadNextPage; // Callback opcional para cargar más películas al acercarse al final del scroll

  const MoviesMasonry({super.key, required this.movies, this.loadNextPage});

  @override
  State<MoviesMasonry> createState() => _MoviesMasonryState();
}

class _MoviesMasonryState extends State<MoviesMasonry> {
  bool isLastPage = false; //Bandera para indicar que ya no hay más películas disponibles y evitar peticiones innecesarias
  bool isLoading = false; // Evita disparar múltiples peticiones mientras ya se está cargando una página
  final scrollController = ScrollController(); // Controla el scroll para detectar cuándo se debe cargar la siguiente página

  @override
  void initState() {
    super.initState();
    // Se agrega un listener al ScrollController para detectar cuando el usuario
    // está a 200px del final y disparar la carga de la siguiente página.
    scrollController.addListener(() {
      if (scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent) {
        loadNextPageDispatch();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose(); // Libera el controller y sus listeners para evitar fugas de memoria
    super.dispose();
  }

  // Ejecuta la carga de la siguiente página de películas
  void loadNextPageDispatch() async {
    if (isLoading || isLastPage) { //Si ya se está haciendo una consulta o ya no hay más páginas, se termina la función
      return;
    }
    if (widget.loadNextPage == null) { //Si no hay función que ejecutar, no se sigue con la ejecución
      return;
    }


    // Si pasa todas las validaciones, inicia la petición
    isLoading = true; //Se cambia la bandera para evitar más peticiones
    final movies = await widget.loadNextPage!(); //Se obtienen las películas
    isLoading = false; //Se libera la petición

    //Si no regresa nada, se marca la última página para ya no hacer más peticiones
    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3, //3 columnas
        mainAxisSpacing: 10, //Espacio entre columnas
        crossAxisSpacing: 10, //Espacio entre filas
        itemCount: widget.movies.length, //Total de películas
        itemBuilder: (context, index) {
          // Se agrega espacio al segundo elemento para crear un efecto visual irregular
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 20),
                MoviePosterLink(movie: widget.movies[index]),
              ],
            );
          }
          return MoviePosterLink(movie: widget.movies[index]); //Widget para mostrar película
        },
      ),
    );
  }
}
