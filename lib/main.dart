import 'package:flutter/material.dart';
import 'package:pmsn20252/screens/home_screen.dart';
import 'package:pmsn20252/screens/list_movies.dart';
import 'package:pmsn20252/screens/login_screen.dart';
import 'package:pmsn20252/screens/player_details_screen.dart';
import 'package:pmsn20252/screens/players_screen.dart';
import 'package:pmsn20252/screens/register_screen.dart';
import 'package:pmsn20252/screens/screen_figma1.dart';
import 'package:pmsn20252/screens/screen_figma2.dart';
import 'package:pmsn20252/utils/theme_app.dart';
import 'package:pmsn20252/utils/value_listener.dart'; // Agregar esta importación

void main() => runApp(MyApp());

class MyApp extends StatelessWidget { // Cambiado a StatelessWidget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ValueListener.isDark,
      builder: (context, value, _) { //Se agrega el _ para indicar que no se usa
        return MaterialApp(
          theme: value ? ThemeApp.lightTheme() : ThemeApp.darkTheme(), // Aquí aplicamos el tema según el valor de isDark es un if pero con operadores ternarios, en caso de tener mas temas podremos usar switch
          routes: {
            "/login": (context) => LoginScreen(),
            "/home": (context) => HomeScreen(), // Ruta para HomeScreen
            "/players": (context) => PlayersSCreen(), // Ruta para PlayersScreen
            "/player_details": (context) => PlayerDetailScreen(), // Ruta para PlayerDetailsScreen
            "/register": (context) => RegisterScreen(),
            "/figma1": (context) => ScreenFigma1(),
            "/figma2": (context) => ScreenFigma2(),
            "/listdb": (context) => ListMovies(),
          },
          debugShowCheckedModeBanner: false,
          title: "Material App",
          home: LoginScreen(), // Aquí indicamos que LoginScreen será la pantalla principal
        );
      }
    );
  }
}