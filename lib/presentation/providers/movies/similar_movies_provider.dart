import 'package:cinemapedia/config/errors/errors.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/legacy.dart';

final similarMoviesProvider =
    StateNotifierProvider<SimilarMoviesNotifier, SimilarMoviesState>((ref) {
      final moviesRepository = ref.watch(movieRepositoryProvider);

      return SimilarMoviesNotifier(
        getSimilarMovies: moviesRepository.getSimilarMovies,
      );
    });

typedef GetSimilarMoviesCallback = Future<List<Movie>> Function(String movieId);

class SimilarMoviesNotifier extends StateNotifier<SimilarMoviesState> {
  final GetSimilarMoviesCallback getSimilarMovies;

  SimilarMoviesNotifier({required this.getSimilarMovies})
    : super(SimilarMoviesState());

  Future<void> loadSimilarMovies(String movieId) async {
    if (state.similarMovies[movieId] != null) return;

    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final List<Movie> movies = await getSimilarMovies(movieId);
      final updatedMovies = {...state.similarMovies, movieId: movies};

      state = state.copyWith(isLoading: false, similarMovies: updatedMovies);
    } on NetworkException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "No hay conexión a internet",
      );
    } on UnauthorizedException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Acceso no autorizado",
      );
    } on MovieDbException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Error al buscar los actores",
      );
    } on MovieNotFoundException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "No se encontró la película",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Ocurrió un error inesperado",
      );
    }
  }
}

class SimilarMoviesState {
  final Map<String, List<Movie>> similarMovies;
  final bool isLoading;
  final String? errorMessage;

  SimilarMoviesState({
    this.similarMovies = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  SimilarMoviesState copyWith({
    Map<String, List<Movie>>? similarMovies,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SimilarMoviesState(
      similarMovies: similarMovies ?? this.similarMovies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
