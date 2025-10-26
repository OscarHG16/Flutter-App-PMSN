import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pmsn20252/screens/trip_detail_screen.dart';
import 'package:pmsn20252/widgets/serviceCard_widget.dart';
import 'package:pmsn20252/widgets/trip_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pmsn20252/database/database_helper.dart'; 
import 'package:pmsn20252/models/trip.dart';
import 'package:pmsn20252/widgets/trips_carousel_widget.dart'; 

class ScreenFigma2 extends StatefulWidget {
  const ScreenFigma2({super.key});

  @override
  State<ScreenFigma2> createState() => _ScreenFigma2State();
}

class _ScreenFigma2State extends State<ScreenFigma2> {
  DatabaseHelper? dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

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
                  Image.asset("assets/blur.jpg", fit: BoxFit.cover),
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
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
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
            child: FutureBuilder<List<Trip>>(
              future: dbHelper!.getAllTrips(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading trips',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (snapshot.hasData) {
                  final trips = snapshot.data!;

                  if (trips.isEmpty) {
                    return Center(
                      child: Text(
                        'No trips available',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // 👇 NUEVO: Header de "Featured Trips"
                      const Text(
                        "FEATURED TRIPS",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TripsCarouselWidget(
                        trips: trips.take(4).toList(), // Mostrar máximo 4 trips
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        "ALL TRIP IDEAS",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      ...trips.map((trip) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TripCard(
                            imageUrl: trip.image,
                            duration: trip.duration,
                            rating: trip.rating,
                            title: trip.title,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TripDetailScreen(trip: trip),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
          } else if (index == 1) {
            Navigator.pushNamed(context, '/calendar');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/manage_bookings');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Symbols.home, color: Colors.black),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Symbols.calendar_month,
              color: Colors.black,
            ), 
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book_online,
              color: Colors.black,
            ), 
            label: "Bookings",
          ),
        ],
      ),
       floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/manage_trips');
        },
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
        label: const Text(
          'Manage',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}