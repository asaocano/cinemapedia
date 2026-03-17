import 'package:cinemapedia/presentation/stores/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final isFavoriteMovieProvider = FutureProvider.family.autoDispose<bool, int>(( //autoDispose es para que se reinicie el estado cuando se destruye el widget que lo escucha
//Provider para almacenar si una película es favorita (Para marcar el botón de favoritos o no)
final isFavoriteMovieProvider = FutureProvider.family<bool, int>((
  ref,
  movieId,
) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider); // Se obteniene el repositorio de almacenamiento local

  return localStorageRepository.isFavoriteMovie(movieId); //Se crea el notifier que manejará el estado
});
