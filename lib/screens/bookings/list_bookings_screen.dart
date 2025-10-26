import 'package:flutter/material.dart';
import 'package:pmsn20252/database/database_helper.dart';
import 'package:pmsn20252/models/booking.dart';
import 'package:pmsn20252/screens/bookings/add_booking_screen.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

class ListBookingsScreen extends StatefulWidget {
  const ListBookingsScreen({super.key});

  @override
  State<ListBookingsScreen> createState() => _ListBookingsScreenState();
}

class _ListBookingsScreenState extends State<ListBookingsScreen> {
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
          "Manage Bookings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          // Botón para agregar nueva reservación
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddBookingScreen(),
                ),
              ).then((_) {
                setState(() {
                  print('Actualizando lista de bookings');
                });
              });
            },
            icon: const Icon(Icons.add_circle),
            iconSize: 30,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper!.getBookingsWithTripInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error al cargar bookings: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'Error loading bookings',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData) {
            final bookingsData = snapshot.data!;
            print('Bookings cargados: ${bookingsData.length}');

            if (bookingsData.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No bookings yet',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tap + to add your first booking',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            //Mostrar lista de bookings
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookingsData.length,
              itemBuilder: (context, index) {
                final bookingData = bookingsData[index];
                
                // Convertir el Map a Booking
                final booking = Booking.fromMap(bookingData);
                
                final tripTitle = bookingData['tripTitle'] ?? 'Unknown Trip';
                final tripLocation = bookingData['tripLocation'] ?? '';
                final tripImage = bookingData['tripImage'] ?? '';

                // Formatear las fechas
                final dateFormat = DateFormat('MMM dd, yyyy');
                final travelDateStr = dateFormat.format(booking.travelDate);
                final bookingDateStr = dateFormat.format(booking.bookingDate);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          image: tripImage.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(tripImage),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: tripImage.isEmpty ? Colors.grey[300] : null,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tripTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (tripLocation.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      tripLocation,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              Icons.person,
                              'Guest',
                              booking.userName,
                              Colors.blue,
                            ),
                            const SizedBox(height: 8),

                            _buildInfoRow(
                              Icons.email,
                              'Email',
                              booking.userEmail,
                              Colors.blue,
                            ),
                            const SizedBox(height: 8),

                            _buildInfoRow(
                              Icons.flight_takeoff,
                              'Travel Date',
                              travelDateStr,
                              Colors.green,
                            ),
                            const SizedBox(height: 8),

                            _buildInfoRow(
                              Icons.people,
                              'Travelers',
                              '${booking.numberOfPeople} person${booking.numberOfPeople > 1 ? 's' : ''}',
                              Colors.orange,
                            ),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: _getStatusColor(booking.status),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Status:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(booking.status)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _getStatusColor(booking.status),
                                    ),
                                  ),
                                  child: Text(
                                    booking.status.toUpperCase(),
                                    style: TextStyle(
                                      color: _getStatusColor(booking.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            Text(
                              'Booked on: $bookingDateStr',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      print('Editando booking ID: ${booking.id}');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddBookingScreen(
                                            booking: booking,
                                          ),
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
                                    onPressed: () {
                                      _showDeleteDialog(booking);
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

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteDialog(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Delete Booking",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "¿Está seguro de que desea eliminar esta reserva para *${booking.userName}*?",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('Eliminación cancelada');
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              print('Eliminando booking ID: ${booking.id}');

              final result = await dbHelper!.deleteBooking(booking.id!);

              String message;
              if (result > 0) {
                message = "Booking deleted successfully";
                print('Booking eliminado correctamente');
              } else {
                message = "Failed to delete booking";
                print('Error al eliminar booking');
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