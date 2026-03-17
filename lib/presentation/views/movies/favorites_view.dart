import 'package:cinemapedia/presentation/stores/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState(); 
}

//El widget se envuelve en un consumer state para poder escuchar a provider
class _FavoritesViewState extends ConsumerState<FavoritesView> {
  @override
  void initState() {
    ref.read(favoriteMoviesProvider.notifier).loadNextPage(); //En cuanto se inicia o se crea el widget, se buscan las primeras 10 películas
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider); //Se obtienen las películas favoritas
    final movieList = favoriteMovies.values.toList(); //Se convierte a lista para poder usarlas
    final colorPrimary = Theme.of(context).colorScheme.primary;
    
    // Si no hay películas favoritas, se muestra un mensaje
    if (movieList.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 100, color: colorPrimary),
              const Text('No tienes películas favoritas :(', style: TextStyle(color: Colors.grey),)
            ],
          ),
        ),
      );
    }
    return Scaffold(
      //Se regresa un widget para mostrar las películas
      body: MoviesMasonry(
        movies: movieList, //Películas actuales
        loadNextPage: () => //Función para cargar más películas
            ref.read(favoriteMoviesProvider.notifier).loadNextPage(),
      ),
    );
  }
}
