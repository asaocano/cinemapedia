import 'package:cinemapedia/presentation/views/views.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  final int viewIndex;
  static const name = 'home-screen';

  const HomeScreen({super.key, required this.viewIndex});

  final viewRoutes = const <Widget>[HomeView(), SizedBox(), FavoritesView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        //Componente para mostrar una navegación mediante pestañas
        index: viewIndex, //Índice de la pestaña actual
        children: viewRoutes, //Lista de vistas que se mostrarán
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: viewIndex),
    );
  }
}
