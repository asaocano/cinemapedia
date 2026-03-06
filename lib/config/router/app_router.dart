import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    //Ruta base usando la vista seleccionada como parámetro
    GoRoute(
      path: '/home/:view',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['view'] ?? '0');
        return HomeScreen(viewIndex: pageIndex);
      },
      //Rutas anidadas
      routes: [
        GoRoute(
          path: 'movie/:id', //Película usando el id como parámetro
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(movieId: movieId);
          },
        ),
      ],
    ),
    //La ruta base redirige a la primera vista
    GoRoute(path: '/', redirect: (_, __) => '/home/0'),
  ],
);
