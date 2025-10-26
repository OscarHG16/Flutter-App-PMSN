import 'package:flutter/material.dart';

// En esta clase definimos los temas de la app
class ThemeApp {

  // Tema oscuro (con contraste mejorado)
  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        // Colores base de la UI
        primary: Colors.blueGrey[800]!,      // Un gris azulado oscuro para elementos principales
        secondary: Colors.tealAccent[700]!, // Un acento de color vibrante
        surface: Colors.grey[850]!,         // Fondo para componentes como Cards
        background: Colors.grey[900]!,      // Fondo general de la app
        error: Colors.redAccent[400]!,      // Color para errores

        // Colores del TEXTO y los ÍCONOS ("on" top of)
        onPrimary: Colors.white,            // Texto sobre el color primario
        onSecondary: Colors.black,          // Texto sobre el color secundario
        onSurface: Colors.white,            // Texto sobre las superficies
        onBackground: Colors.white,         // Texto sobre el fondo general
        onError: Colors.black,              // Texto sobre el color de error
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,      // CAMBIO: Asegura que el título y los íconos del AppBar sean blancos
        elevation: 0
      ),
      scaffoldBackgroundColor: Colors.grey[900]
    );
  }

  // Método para tema claro (CORREGIDO)
  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(
        // Colores base de la UI
        primary: Colors.blue[800]!,         // CAMBIO: Un azul oscuro como color principal
        secondary: Colors.teal[500]!,       // Un color secundario agradable
        surface: Colors.white,              // CAMBIO: Un blanco limpio para las superficies
        background: Colors.grey[100]!,      // Un gris muy claro para el fondo
        error: Colors.red[700]!,

        // Colores del TEXTO y los ÍCONOS ("on" top of)
        onPrimary: Colors.white,            // CAMBIO: Texto blanco sobre el azul primario
        onSecondary: Colors.white,          // CAMBIO: Texto blanco sobre el color secundario
        onSurface: Colors.grey[900]!,       // CAMBIO CLAVE: Texto oscuro sobre las superficies blancas
        onBackground: Colors.grey[900]!,    // CAMBIO: Texto oscuro sobre el fondo general
        onError: Colors.white,              // CAMBIO: Texto blanco sobre el fondo de error
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue[800]!, // CAMBIO: Mismo color que el primario para consistencia
        foregroundColor: Colors.white,      // CAMBIO: Asegura que el texto y los íconos sean blancos
        elevation: 0
      ),
      scaffoldBackgroundColor: Colors.grey[100]
    );
  }
}