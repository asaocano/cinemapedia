import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return
    //El SafeArea se usa para evitar interferencias del dispositivo como el notch (android) o el dynamic island (iOS)
    SafeArea(
      bottom: false,
      child:
          //Le agrega una separación horizontal al safearea de 10 para separarlo de la pantalla
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.movie_creation_outlined, color: colors.primary),
                  const SizedBox(width: 5),
                  Text('Cinemapedia', style: titleStyle),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      //* Se usan estos providers para volver a cargar la búsqueda que el usuario había hecho previamente
                      //* Se usa .read en lugar de watch para leer el estado anterior, no se necesita estar escuchando los cambios constantemente
                      final searchedMovies = ref.read(searchedMoviesProvider); //* Lista de películas que el usuario ya buscó previamente
                      final searchQuery = ref.read(searchQueryProvider); //* Texto que el usuario había buscado previamente

                      //* Película que se obtiene de la búsqueda realizada mediante el search delegate
                      final movie = await showSearch<Movie?>( //* Función propia de flutter para desplegar una pantalla de búsqueda
                        query: searchQuery, //* Texto que previamente se había buscado
                        context: context,
                        delegate: SearchMovieDelegate( //* Clase que controla todo el comportamiento del buscador (Qué mostrar cuando no hay texto, Qué mostrar cuando se escribe, Qué pasa cuando se selecciona algo, Cómo se renderiza cada resultado)
                          initialMovies: searchedMovies, //* Películas iniciales que se mostrarán en el buscador (En caso de que sea estado inicial o se haya borrado la búsqueda, estará vacío)
                          searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery //* Se pasa la referencia de la función que realizará la búsqueda en la api (Se ejecuta dentro de la clase delegate)
                        ),
                      );

                      if (movie == null) return;  //* Si no hay película, no se hace nada

                      if (!context.mounted) return; //* Verifica que el widget siga montado después del await para evitar errores al navegar

                      context.push('/home/0/movie/${movie.id}'); //* Si se selecciona una película de la lista, se envía a la pantalla que muestra los detalles de la película
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
