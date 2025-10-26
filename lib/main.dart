import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pmsn20252/database/database_helper.dart';
import 'package:pmsn20252/firebase_options.dart';
import 'package:pmsn20252/screens/add_movie_creen.dart';
import 'package:pmsn20252/screens/bookings/add_booking_screen.dart';
import 'package:pmsn20252/screens/bookings/list_bookings_screen.dart';
import 'package:pmsn20252/screens/calendar_screen.dart';
import 'package:pmsn20252/screens/home_screen.dart';
import 'package:pmsn20252/screens/list_api_movies.dart';
import 'package:pmsn20252/screens/list_movies.dart';
import 'package:pmsn20252/screens/list_songs_screen.dart';
import 'package:pmsn20252/screens/login_screen.dart';
import 'package:pmsn20252/screens/player_details_screen.dart';
import 'package:pmsn20252/screens/players_screen.dart';
import 'package:pmsn20252/screens/playstation_store_screen.dart';
import 'package:pmsn20252/screens/register_screen.dart';
import 'package:pmsn20252/screens/screen_figma1.dart';
import 'package:pmsn20252/screens/screen_figma2.dart';
import 'package:pmsn20252/screens/statistics_screen.dart';
import 'package:pmsn20252/screens/trips/list_trips_screen.dart'; 
import 'package:pmsn20252/screens/trips/add_trip_screen.dart';  
import 'package:pmsn20252/utils/theme_app.dart';
import 'package:pmsn20252/utils/value_listener.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado correctamente');
  } catch (e) {
    print('⚠️ Error al inicializar Firebase: $e');
  }
  
  try {
    final dbHelper = DatabaseHelper();
    await dbHelper.insertInitialTrips();
    print('✅ Base de datos inicializada correctamente');
  } catch (e) {
    print('❌ Error al inicializar BD: $e');
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget { 
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
            "/ps_store": (context) => PlaystationStoreScreen(),
            "/add": (context) => AddMovieScreen(),
            "/songs": (context) => ListSongsScreen(),
            "/manage_trips": (context) => ListTripsScreen(),
            "/add_trip": (context) => AddTripScreen(),
            "/api": (context) => const ListApiMovies(),
            "/manage_bookings": (context) => ListBookingsScreen(), 
            "/add_booking": (context) => AddBookingScreen(), 
            "/calendar": (context) => CalendarScreen(),
            "/statistics": (context) => StatisticsScreen(),
            
          },
          debugShowCheckedModeBanner: false,
          title: "Material App",
          home: LoginScreen(), // Aquí indicamos que LoginScreen será la pantalla principal
        );
      }
    );
  }
}