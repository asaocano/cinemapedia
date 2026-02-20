import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final nowPlayingMoviesProvider =
    //Crea un StateNotifierProvider que expone un estado de tipo List<Movie>.
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      //Obtiene el repository usando ref.watch(movieRepositoryProvider) y
      //extrae el método getNowPlaying del repository
      final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
      // Pasa el método getNowPlaying al MoviesNotifier como fetchMoreMovies
      return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
    });

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    
    if (isLoading) {
      return;
    } else {
      isLoading = true;
      currentPage++;

      final List<Movie> movies = await fetchMoreMovies(page: currentPage);
      state = [...state, ...movies];
      await Future.delayed(const Duration(milliseconds: 300));
      isLoading = false;
    }
  }
}
