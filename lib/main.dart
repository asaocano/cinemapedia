import 'package:cinemapedia/presentation/providers/settings/dark_mode_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Se agrega soporte para drift (db local)

  // await db
  //     .into(db.favoriteMovies)
  //     .insert(
  //       FavoriteMoviesCompanion.insert(
  //         movieId: 1,
  //         backdropPath: 'backdropPath.png',
  //         originalTitle: 'originalTitle',
  //         posterPath: 'posterPath.png',
  //         title: 'title',
  //       ),
  //     );
  // final deleteQuery = db.delete(db.favoriteMovies);
  // await deleteQuery.go();

  // final movies = await db.select(db.favoriteMovies).get();
  await initializeDateFormatting(
    'es',
    null,
  ); //Se agrega soporte para formatear fechas en español
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
    );
  }
}
