import 'package:flutter/material.dart';
import 'package:pmsn20252/database/database_helper.dart';
import 'package:pmsn20252/models/trip.dart';
import 'package:pmsn20252/screens/trips/add_trip_screen.dart';

class ListTripsScreen extends StatefulWidget {
  const ListTripsScreen({super.key});

  @override
  State<ListTripsScreen> createState() => _ListTripsScreenState();
}

class _ListTripsScreenState extends State<ListTripsScreen> {
  DatabaseHelper? dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: const Text(
          "Manage Trips",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        actions: [
          IconButton( //Este es el boton para las estdisticas
            onPressed: () {
              Navigator.pushNamed(context, '/statistics');
            },
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Statistics',
          ),
          IconButton( //Boton para agregar un nuevo trip
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddTripScreen()),
              ).then((_) {
              });
            },
            icon: const Icon(Icons.add_circle),
            iconSize: 30,
          ),
        ],
      ),
      body: FutureBuilder<List<Trip>>(
        // Obtenemos todos los trips de la BD
        future: dbHelper!.getAllTrips(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error al cargar trips: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'Error loading trips',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ],
              ),
            );
          }
          
          // Si tiene datos
          if (snapshot.hasData) {
            final trips = snapshot.data!;
            print('Trips cargados: ${trips.length}');
            
            // Si no hay trips
            if (trips.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.travel_explore,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No trips available',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tap + to add your first trip',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: trips.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final trip = trips[index];
                
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Imagen del trip
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          trip.image,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 60,
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Información del trip
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título
                            Text(
                              trip.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            
                            // Ubicación y duración
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  trip.location,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  trip.duration,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            // Rating y costo
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  trip.rating,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '\$${trip.cost}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddTripScreen(trip: trip),
                                        ),
                                      ).then((_) {
                                        setState(() {});
                                      });
                                    },
                                    icon: const Icon(Icons.edit, size: 18),
                                    label: const Text('Edit'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      _showDeleteDialog(trip);
                                    },
                                    icon: const Icon(Icons.delete, size: 18),
                                    label: const Text('Delete'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(Trip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Delete Trip",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "¿Estás seguro de que deseas eliminar '${trip.title}'?\n\nEsto también eliminará todas las reservas asociadas con este viaje.",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          // Botón CANCELAR
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          
          TextButton(
            onPressed: () async {
              final result = await dbHelper!.deleteTrip(trip.id!);
              
              String message;
              if (result > 0) {
                message = "Trip deleted successfully";
                print('Trip eliminado correctamente');
              } else {
                message = "Failed to delete trip";
                print('Error al eliminar trip');
              }
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: result > 0 ? Colors.green : Colors.red,
                  ),
                );
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}