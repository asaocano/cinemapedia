import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/similar_movies_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/providers/trailers/trailers_by_movie_provider.dart';
import 'package:cinemapedia/presentation/stores/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/stores/is_favorite_movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
      ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
      ref.read(trailerProvider.notifier).searchTrailer(widget.movieId);
      ref
          .read(similarMoviesProvider.notifier)
          .loadSimilarMovies(widget.movieId);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    ref.listen(actorsByMovieProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.errorMessage!,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    if (movie == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final favoriteMovies = ref.watch(favoriteMoviesProvider);
    final isFavorite = favoriteMovies.containsKey(movie.id);

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        //Botón para marcar como favorito
        IconButton(
          onPressed: () {
            ref
                .read(favoriteMoviesProvider.notifier)
                .toggleFavoriteMovie(movie);
          },
          icon: isFavorite
              ? const Icon(Icons.favorite, color: Colors.red)
              : const Icon(Icons.favorite_border_rounded),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(color: Colors.white, fontSize: 20),
        //   textAlign: TextAlign.left,
        // ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return SizedBox();
                  } else {
                    return FadeIn(child: child);
                  }
                },
              ),
            ),
            //Sombra al final del poster
            const _CustomGradient(
              inicio: Alignment.topCenter,
              fin: Alignment.bottomCenter,
              stops: [0.7, 1.0],
              colores: [Colors.transparent, Colors.black87],
            ),
            //Sombra al botón de regreso
            const _CustomGradient(
              inicio: Alignment.topLeft,
              stops: [0.0, 0.3],
              colores: [Colors.black87, Colors.transparent],
            ),
            //Sombra al botón favoritos
            const _CustomGradient(
              inicio: Alignment.topRight,
              fin: Alignment.bottomLeft,
              stops: [0.0, 0.3],
              colores: [Colors.black87, Colors.transparent],
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final dateFormatter = DateFormat('EEE, dd MMM yyyy', 'es_MX');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MovieInfo(
          movie: movie,
          size: size,
          textStyles: textStyles,
          colors: colors,
          dateFormatter: dateFormatter,
        ),
        //Generos
        _MovieGenres(movie: movie),
        //Actores
        _ActorsByMovie(movieId: movie.id.toString()),
        //Trailer
        _MovieTrailer(movieId: movie.id.toString(), textStyles: textStyles),
        const SizedBox(height: 30),
        //Sugerencias
        _SimilarMovies(movieId: movie.id.toString(), textStyles: textStyles),
        const SizedBox(height: 50),
      ],
    );
  }
}

class _MovieGenres extends StatelessWidget {
  const _MovieGenres({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            ...movie.genreIds.map(
              (gender) => Container(
                margin: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieInfo extends StatelessWidget {
  const _MovieInfo({
    required this.movie,
    required this.size,
    required this.textStyles,
    required this.colors,
    required this.dateFormatter,
  });

  final Movie movie;
  final Size size;
  final TextTheme textStyles;
  final ColorScheme colors;
  final DateFormat dateFormatter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //poster
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(movie.posterPath, width: size.width * 0.3),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: (size.width - 40) * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textStyles.titleLarge), //Titulo
                Text(movie.overview), //Sinopsis
                Padding(
                  //Rating
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star_half_outlined,
                            color: Colors.yellow.shade800,
                          ),
                          Text(
                            "${HumanFormat.scoreTransform(movie.voteAverage)}/10",
                            style: textStyles.bodyMedium?.copyWith(
                              color: Colors.yellow.shade800,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        //Fecha de estreno
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: colors.primary,
                          ),
                          Text.rich(
                            TextSpan(
                              text: "Estreno: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: dateFormatter.format(
                                    movie.releaseDate ?? DateTime.now(),
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie.isLoading) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    if (actorsByMovie.actors[movieId] == null) {
      return const SizedBox();
    }

    final actors = actorsByMovie.actors[movieId]!;

    if (actors.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Foto
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //Nombre
                const SizedBox(height: 5),
                Text(actor.name, maxLines: 2),
                Text(
                  actor.character ?? '',
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SimilarMovies extends ConsumerWidget {
  final String movieId;
  final TextTheme textStyles;
  const _SimilarMovies({required this.movieId, required this.textStyles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarMoviesArray = ref.watch(similarMoviesProvider).similarMovies;
    final similarMovies = similarMoviesArray[movieId];

    if (similarMovies == null) {
      return Placeholder();
    }

    return SizedBox(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('También te podría gustar', style: textStyles.titleLarge),
            Expanded(
              child: ListView.builder(
                itemCount: similarMovies.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final movie = similarMovies[index];
                  return _SimilarMovie(movie: movie);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieTrailer extends ConsumerWidget {
  final String movieId;
  final TextTheme textStyles;

  const _MovieTrailer({required this.movieId, required this.textStyles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trailerId = ref.watch(trailerProvider)[movieId] ?? "";

    if (trailerId == "") {
      return const SizedBox.shrink();
    }

    final controller = YoutubePlayerController(
      initialVideoId: trailerId,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trailer', style: textStyles.titleLarge,),
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,

              // Quitamos el botón fullscreen
              bottomActions: [
                const SizedBox(width: 14),
                CurrentPosition(),
                const SizedBox(width: 8),
                ProgressBar(isExpanded: true),
                const SizedBox(width: 8),
                RemainingDuration(),
              ],
            ),

            builder: (context, player) {
              return player;
            },
          ),
        ],
      ),
    );
  }
}

//Componente para película individual
class _SimilarMovie extends StatelessWidget {
  const _SimilarMovie({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          //Inicia bloque de película
          crossAxisAlignment: CrossAxisAlignment
              .center, //Horizontalmente se alinea al centro del contenedor
          children: [
            SizedBox(
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  height: 130,
                  loadingBuilder: //Imagen provisional mientras carga la imagen en línea
                  (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return const Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    return GestureDetector(
                      child: FadeIn(child: child),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              movie.title,
              maxLines: 2,
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

//Componente para añadir un gradiente
class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry inicio;
  final AlignmentGeometry fin;
  final List<double> stops;
  final List<Color> colores;

  const _CustomGradient({
    this.inicio = Alignment.topCenter,
    this.fin = Alignment.centerRight,
    required this.stops,
    required this.colores,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: inicio,
            end: fin,
            stops: stops,
            colors: colores,
          ),
        ),
      ),
    );
  }
}
