import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

//Función para regresar los mensajes de carga periódicamente
  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Cargando películas',
      'Cocinando palomitas',
      'Comprando entradas',
      'Seleccionando asientos',
      'Sirviendo dulces',
      'Preparando pantalla',
      'Realizando pruebas de audio',
    ];

    //Cada 1200 milisegundos se regresa el mensaje correspondiente a la posición
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);//Se detiene automáticamente cuando llega al final de la lista
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Cargando...');
              } else {
                return Text(snapshot.data!);
              }
            },
          ),
        ],
      ),
    );
  }
}
