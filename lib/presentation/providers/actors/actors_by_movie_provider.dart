import 'package:cinemapedia/config/errors/errors.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, ActorsByMovieState>((
      ref,
    ) {
      final actorsRepository = ref.watch(actorRepositoryProvider);

      return ActorsByMovieNotifier(
        getActors: actorsRepository.getActorsByMovie,
      );
    });

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<ActorsByMovieState> {
  final GetActorsCallback getActors;

  ActorsByMovieNotifier({required this.getActors})
    : super(ActorsByMovieState());

  Future<void> loadActors(String movieId) async {
    if (state.actors[movieId] != null) return;

    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final List<Actor> actors = await getActors(movieId);
      final updatedActors = {...state.actors, movieId: actors};

      state = state.copyWith(isLoading: false, actors: updatedActors);
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

class ActorsByMovieState {
  final Map<String, List<Actor>> actors;
  final bool isLoading;
  final String? errorMessage;

  ActorsByMovieState({
    this.actors = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  ActorsByMovieState copyWith({
    Map<String, List<Actor>>? actors,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ActorsByMovieState(
      actors: actors ?? this.actors,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
