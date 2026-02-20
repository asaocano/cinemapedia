import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const name = 'home-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final nowPlayingMoviesSlide = ref.watch(moviesSlideShowProvider);

    if (nowPlayingMovies.isEmpty) {
      return CircularProgressIndicator();
    }

    return Column(
      children: [
        CustomAppbar(),
        MoviesSlideshow(movies: nowPlayingMoviesSlide),
        MovieHorizontalListview(
          movies: nowPlayingMovies,
          title: 'En cines',
          subtitle: 'Lunes 20',
          loadNextPage: () {
            ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
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
  }
}
