import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pmsn20252/database/database_helper.dart';
import 'package:pmsn20252/models/booking.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DatabaseHelper? dbHelper;

  // Variables para el calendario
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mapa para guardar bookings por fecha
  Map<DateTime, List<Map<String, dynamic>>> _bookingsByDate = {};

  // Lista de bookings del día seleccionado
  List<Map<String, dynamic>> _selectedDayBookings = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _selectedDay = _focusedDay;
    _loadBookings();
  }

  // Cargar todas las bookings y organizarlas por fecha
  Future<void> _loadBookings() async {
    try {

      // Obtenemos todas las bookings con info del trip (usando JOIN)
      final bookingsData = await dbHelper!.getBookingsWithTripInfo();

      // Organizamos las bookings por fecha
      Map<DateTime, List<Map<String, dynamic>>> groupedBookings = {};

      for (var bookingData in bookingsData) {
        final booking = Booking.fromMap(bookingData);

        // Extraemos solo la fecha (sin hora) para agrupar
        final dateKey = DateTime(
          booking.travelDate.year,
          booking.travelDate.month,
          booking.travelDate.day,
        );

        // Agregamos el booking a la lista de ese día
        if (groupedBookings[dateKey] == null) {
          groupedBookings[dateKey] = [];
        }
        groupedBookings[dateKey]!.add(bookingData);
      }

      setState(() {
        _bookingsByDate = groupedBookings;
        isLoading = false;

        // Cargar bookings del día seleccionado
        _updateSelectedDayBookings(_selectedDay!);
      });
    } catch (e) {
      print('Error cargando bookings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Actualizar la lista de bookings del día seleccionado
  void _updateSelectedDayBookings(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    _selectedDayBookings = _bookingsByDate[dateKey] ?? [];
  }

  List<Map<String, dynamic>> _getBookingsForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return _bookingsByDate[dateKey] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Calendar",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.purple[700],
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bookings Calendar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
        actions: [
          // Botón para recargar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _loadBookings();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendario
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              // Detectar días con bookings
              eventLoader: _getBookingsForDay,
              // Cuando cambia el día seleccionado
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _updateSelectedDayBookings(selectedDay);
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.purple[300],
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.purple[700],
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.orange[700],
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: const TextStyle(color: Colors.red),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.purple[700],
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.event_note,
                  color: Colors.purple[700],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedDayBookings.isEmpty
                      ? 'No bookings for this day'
                      : 'Bookings (${_selectedDayBookings.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _selectedDayBookings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No bookings on this date',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _selectedDayBookings.length,
                    itemBuilder: (context, index) {
                      final bookingData = _selectedDayBookings[index];
                      final booking = Booking.fromMap(bookingData);

                      final tripTitle = bookingData['tripTitle'] ?? 'Unknown';
                      final tripLocation = bookingData['tripLocation'] ?? '';
                      final tripImage = bookingData['tripImage'] ?? '';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            _showBookingDetails(bookingData);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Imagen del trip
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: tripImage.isNotEmpty
                                      ? Image.network(
                                          tripImage,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 80,
                                              height: 80,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image),
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image),
                                        ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Título del trip
                                      Text(
                                        tripTitle,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),

                                      // Ubicación
                                      if (tripLocation.isNotEmpty)
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 14,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              tripLocation,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(height: 4),

                                      // Usuario y personas
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              '${booking.userName} (${booking.numberOfPeople} travelers)',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(booking.status)
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: _getStatusColor(booking.status),
                                          ),
                                        ),
                                        child: Text(
                                          booking.status.toUpperCase(),
                                          style: TextStyle(
                                            color: _getStatusColor(booking.status),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey[400],
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

  void _showBookingDetails(Map<String, dynamic> bookingData) {
    final booking = Booking.fromMap(bookingData);
    final tripTitle = bookingData['tripTitle'] ?? 'Unknown';
    final tripLocation = bookingData['tripLocation'] ?? '';
    final tripDuration = bookingData['tripDuration'] ?? '';

    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle para arrastrar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Título
                  const Text(
                    'Booking Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Trip info
                  _buildDetailRow(Icons.flight_takeoff, 'Trip', tripTitle),
                  _buildDetailRow(Icons.location_on, 'Location', tripLocation),
                  _buildDetailRow(Icons.access_time, 'Duration', tripDuration),
                  const Divider(height: 30),

                  // Booking info
                  _buildDetailRow(Icons.person, 'Guest', booking.userName),
                  _buildDetailRow(Icons.email, 'Email', booking.userEmail),
                  _buildDetailRow(
                    Icons.people,
                    'Travelers',
                    '${booking.numberOfPeople} person${booking.numberOfPeople > 1 ? 's' : ''}',
                  ),
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Travel Date',
                    dateFormat.format(booking.travelDate),
                  ),
                  _buildDetailRow(
                    Icons.event,
                    'Booked On',
                    dateFormat.format(booking.bookingDate),
                  ),

                  const SizedBox(height: 16),

                  // Estado
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: _getStatusColor(booking.status),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Status:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(booking.status),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          booking.status.toUpperCase(),
                          style: TextStyle(
                            color: _getStatusColor(booking.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Botón cerrar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CLOSE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.purple[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
}