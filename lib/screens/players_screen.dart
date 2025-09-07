import 'package:flutter/material.dart';
import 'dart:math' show pi; //Este import es para la función de rotación en 3D
import 'package:pmsn20252/data/players_data.dart'; //Este import es para traer la lista de jugadores
import 'package:pmsn20252/widgets/atribute_widget.dart'; //Aqui importamos el widget de atributos

class PlayersSCreen extends StatelessWidget {
  PlayersSCreen({super.key});

  // Función para convertir grados a radianes
  double radians(double degrees) => degrees * (pi / 180);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("FC Barcelona - Players"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors
            .transparent, //hacemos que el appBar sea transparente para que se vea el fondo degradado en toda la pantalla
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Fondo degradado azulgrana parsa tematica del FC Barcelona
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 11, 76, 129),
                  Color.fromARGB(255, 236, 55, 42),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Lista de jugadores
          SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: players.length, //Cantidad de jugadores segun la lista
              itemBuilder: (context, index) {
                final player =
                    players[index]; //obtenemos el jugador actual segun el indice
                final double rowHeight =
                    340.0; //Aqui ajustamos la altura de cada fila para que las cards no se vean tan apretadas

                return Container(
                  height: rowHeight,
                  margin: const EdgeInsets.only(
                    bottom: 75,
                  ), //Margen entre las cards
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Capa de fondo 1
                      Transform.translate(
                        offset: const Offset(-10, 0),
                        child: Transform(
                          alignment: FractionalOffset.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.01)
                            ..rotateY(radians(1.5)),
                          child: Container(
                            height:
                                rowHeight -
                                85, //Ajustamos la altura de la capa de fondo 1 que es la mas transparente
                            margin: const EdgeInsets.only(left: 40, right: 25),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                      ),
                      // Capa de fondo 2
                      Transform.translate(
                        offset: const Offset(-44, 0),
                        child: Transform(
                          alignment: FractionalOffset.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.01)
                            ..rotateY(radians(8)),
                          child: Container(
                            height:
                                220, //Ajustamos la altura de la capa de fondo 2 que es la menos transparente
                            margin: const EdgeInsets.only(left: 40, right: 25),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                      ),
                      // Imagen del jugador
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Transform.translate(
                          offset: const Offset(-30, 0),
                          child: Image.network(
                            player.imageUrl,
                            width: rowHeight,
                            height: rowHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Align( // Atributos del jugador
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(right: 45),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AttributeWidget(
                                progress: player.velocidad,
                                size:60, // Tamaño ajustado para caber en la card
                                child: const Icon(
                                  Icons.speed,
                                  color: Colors.white,
                                  size: 25, //tamalo del icono
                                ),
                              ),
                              const SizedBox(height: 10,), // Espacio entre atributos
                              AttributeWidget(
                                progress: player.disparo,
                                size: 60,
                                child: const Icon(
                                  Icons.sports_soccer,
                                  color: Colors.white,
                                  size: 25, //tamalo del icono
                                ),
                              ),
                              const SizedBox(height: 10), // Espacio entre atributos
                              AttributeWidget(
                                progress: player.pase,
                                size: 60,
                                child: const Icon(
                                  Icons.swap_horiz,
                                  color: Colors.white,
                                  size: 25, //tamalo del icono
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
