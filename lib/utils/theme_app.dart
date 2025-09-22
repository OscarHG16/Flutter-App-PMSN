import 'package:flutter/material.dart';

//En esta clase definimos los temas de la app
class ThemeApp {
  // Tema oscuro
  static ThemeData darkTheme(){
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: Colors.grey[800]!,
        onPrimary: Colors.grey[300]!, // Cambio de blanco a gris claro
        secondary: Colors.blueGrey[700]!,
        onSecondary: Colors.grey[400]!, // Cambio de white70 a gris
        error: Colors.red[900]!,
        onError: Colors.grey[300]!, // Cambio de blanco a gris claro
        surface: Colors.grey[800]!,
        onSurface: Colors.grey[400]!, // Cambio de white70 a gris
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        elevation: 0
      ),
      scaffoldBackgroundColor: Colors.grey[900]
    );
  }

  // Método para tema claro 
  static ThemeData lightTheme(){
    return ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(
        primary: Colors.blue[600]!,
        onPrimary: Colors.grey[100]!, // Cambio de blanco a gris muy claro
        secondary: Colors.teal[500]!,
        onSecondary: Colors.grey[200]!, // Cambio de blanco a gris muy claro
        error: Colors.red[700]!,
        onError: Colors.grey[100]!, // Cambio de blanco a gris muy claro
        surface: Colors.grey[50]!, // Cambio de blanco a gris casi blanco
        onSurface: const Color.fromARGB(255, 255, 255, 255), // Cambio de black87 a gris muy oscuro
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 15, 30, 85),
        elevation: 0
      ),
      scaffoldBackgroundColor: Colors.grey[100]
    );
  }
}