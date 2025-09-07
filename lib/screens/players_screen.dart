import 'package:flutter/material.dart';

class PlayersSCreen extends StatelessWidget {
  const PlayersSCreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      //Barra superior
      appBar: AppBar(
        title: const Text("FC Barcelona - Players"),
        backgroundColor: Colors.transparent,
      ),
      //Cuerpo con fondo degradado
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight, 
            ),
        ),
      //Texto centrado
      child: const Center(
        child: Text(
          "Pantalla jugadores FC Barcelona",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        )
        )
      )
    );
  }
}
