import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upComingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    //Revisa que toda la información se haya cargado
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading)
      return FullScreenLoader(); //Si algún provider no se ha terminado de cargar, regresa el widget de cargando

    final nowPlayingMoviesSlide = ref.watch(moviesSlideShowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upComingMovies = ref.watch(upComingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    return
    //SingleChildScrollView: Sirve para dar scroll a la pantalla (De forma que no se desborde)
    //CustomScrollView: sirve para mostrar lo que tú quieras en el scroll view
    CustomScrollView(
      slivers: [
        //Utiliza una lista de slivers (lista de widgets)
        SliverAppBar(
          //SliverAppBar será la appbar que tendrá el scrollview
          floating:
              true, //Ponemos que sea flotante para que al hacer scroll de regreso, se vuelva a mostrar
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ), //El componente que mostraremos (nuestro custom appbar)
          // shadowColor: colors.primary,
        ),
        SliverList(
          //El contenido que queremos mostrar
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                // CustomAppbar(),
                MoviesSlideshow(movies: nowPlayingMoviesSlide),
                //Actuales
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En cines',
                  subtitle: 'En carteleras',
                  loadNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  },
                ),
                //Populares
                MovieHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  // subtitle: 'Lunes 20',
                  loadNextPage: () {
                    ref.read(popularMoviesProvider.notifier).loadNextPage();
                  },
                ),
                //Próximas
                MovieHorizontalListview(
                  movies: upComingMovies,
                  title: 'Próximamente',
                  subtitle: 'Este mes',
                  loadNextPage: () {
                    ref.read(upComingMoviesProvider.notifier).loadNextPage();
                  },
                ),
                //Mejores
                MovieHorizontalListview(
                  movies: topRatedMovies,
                  title: 'Mejor calificadas',
                  subtitle: 'De todos los tiempos',
                  loadNextPage: () {
                    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                  },
                ),

                //Dado el padre, expande el contenido todo lo posible
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: nowPlayingMovies.length,
                //     itemBuilder: (context, index) {
                //       final movie = nowPlayingMovies[index];
                //       return ListTile(title: Text(movie.title));
                //     },
                //   ),
                // ),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
