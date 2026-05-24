import 'package:cinemapedia/presentation/providers/trailers/trailers_repositoy_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final trailerProvider =
    StateNotifierProvider<TrailerMapNotifier, Map<String, String>>((ref) {
      final trailerRepository = ref.watch(trailerRepositoryProvider);

      return TrailerMapNotifier(
        getTrailerByMovieId: trailerRepository.getTrailerIdByMovieId,
      );
    });

typedef GetTrailerCallback = Future<String> Function(String movieId);

class TrailerMapNotifier extends StateNotifier<Map<String, String>> {
  final GetTrailerCallback getTrailerByMovieId;

  TrailerMapNotifier({required this.getTrailerByMovieId}) : super({});

  Future<void> searchTrailer(String movieId) async {
    if (state[movieId] != null) return;

    final trailerId = await getTrailerByMovieId(movieId);

    state = {...state, movieId: trailerId};
  }
}
