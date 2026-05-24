import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigation({super.key, required this.currentIndex});

  void onItemTap(BuildContext context, int index) {
    context.go('/home/$index'); //Se cambia a la pestaña seleccionada
  }

  @override
  Widget build(BuildContext context) {
    //Menú en pestañas
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex, //pestaña actual
      onTap: (value) => onItemTap(context, value),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department_outlined),
          label: 'Populares',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos',
        ),
      ],
    );
  }
}
