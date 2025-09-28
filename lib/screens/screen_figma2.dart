import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pmsn20252/data/trip_data.dart';
import 'package:pmsn20252/screens/trip_detail_screen.dart';
import 'package:pmsn20252/widgets/serviceCard_widget.dart';
import 'package:pmsn20252/widgets/trip_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class ScreenFigma2 extends StatefulWidget {
  const ScreenFigma2({super.key});

  @override
  State<ScreenFigma2> createState() => _nameState();
}

class _nameState extends State<ScreenFigma2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipRRect(
            child: SizedBox(
              height: 320 + MediaQuery.of(context).padding.top,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  //Imagen de fondo
                  Image.asset("assets/blur.jpg", fit: BoxFit.cover),
                  //Aplicamos el blur
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              top: MediaQuery.of(context).padding.top + 35,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning",
                  style: GoogleFonts.inter(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),

                Text(
                  "What do you want to book today?",
                  style: GoogleFonts.inter(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    //Aqui usamos el widget que creamos para las tarjetas de servicios
                    Expanded(
                      child: ServiceCard(icon: Symbols.travel, label: "Flights"),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ServiceCard(
                        icon: Icons.directions_car,
                        label: "Cars",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ServiceCard(icon: Symbols.apartment, label: "Hotels"),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ServiceCard(
                        icon: Icons.directions_boat,
                        label: "Cruises",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 335 + MediaQuery.of(context).padding.top,
            left: 8,
            right: 8,
            bottom: 0,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: tripsData.length + 1,
              itemBuilder: (ctx, i) {
                if (i == 0) { //Para colocar el texto primero lo colocamos en la posicion 0 del widget
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "TRENDING TRIP IDEAS",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }
                final trip = tripsData[i -1]; //Ya que el texto ocupa la posicion 0, los demas datos empiezan en 1, por eso restamos 1
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TripCard( //Aqui usamos el widget que creamos 
                  //Y aqui le pasamos los datos del modelo que se guardan en la data que es trip_data
                    imageUrl: trip.image,
                    duration: trip.duration,
                    rating: trip.rating,
                    title: trip.title,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => TripDetailScreen(trip: trip)));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Symbols.home, color: Colors.black,), label: "",),
          BottomNavigationBarItem(icon: Icon(Symbols.luggage), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }
}
