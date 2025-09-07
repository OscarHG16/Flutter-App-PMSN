import 'package:flutter/material.dart';
import 'package:pmsn20252/models/player.dart';

class PlayersSCreen extends StatelessWidget {
  PlayersSCreen({super.key});

  final List<Player> players = [
    Player(
      name: "Lionel Messi",
      position: "Delantero",
      imageUrl:
          "https://www.pngplay.com/wp-content/uploads/13/Messi-Transparent-PNG.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // permite que el fondo llegue hasta arriba
      appBar: AppBar(
        title: const Text("FC Barcelona - Players"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1️⃣ Fondo degradado ocupa toda la pantalla
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // 2️⃣ Contenido seguro (tarjetas) dentro de SafeArea
          SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: players.length, // Número de jugadores según la lista
              itemBuilder: (context, index) {
                final player =
                    players[index]; // Obtener el jugador actual según el índice
                // Variación de inclinación y desplazamiento según el índice
                final double rotationAngle = -0.05 + index * 0.01; // radianes
                final double translateX =
                    -10.0 * index; // desplazamiento horizontal

                return Transform.translate(
                  offset: Offset(translateX, 0),
                  child: Transform.rotate(
                    angle: rotationAngle,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(
                        20,
                      ), // más aire dentro de la card
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          0.25,
                        ), // un poquito más sólido
                        borderRadius: BorderRadius.circular(
                          24,
                        ), // bordes más suaves
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.2,
                            ), // sombra más sutil
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Imagen del jugador
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              player.imageUrl,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Texto
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20, // un poquito más grande
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                player.position,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
