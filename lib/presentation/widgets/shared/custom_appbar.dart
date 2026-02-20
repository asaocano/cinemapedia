import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return
    //El SafeArea se usa para evitar interferencias del dispositivo como el notch (android) o el dynamic island (iOS)
    SafeArea(
      bottom: false,
      child:
          //Le agrega una separación horizontal al safearea de 10 para separarlo de la pantalla
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.movie_creation_outlined, color: colors.primary),
                  const SizedBox(width: 5),
                  Text('Cinemapedia', style: titleStyle),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      //TODO: Función de búsqueda
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
