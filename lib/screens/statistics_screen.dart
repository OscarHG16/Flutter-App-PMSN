import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pmsn20252/database/database_helper.dart';
import 'package:pmsn20252/models/trip.dart';
import 'package:pmsn20252/models/booking.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DatabaseHelper? dbHelper;
  
  List<Trip> trips = [];
  List<Booking> bookings = [];
  
  bool isLoading = true;

  // Estadísticas
  int totalTrips = 0;
  int totalBookings = 0;
  int pendingBookings = 0;
  int confirmedBookings = 0;
  int cancelledBookings = 0;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      print('Cargando estadísticas');
      
      final loadedTrips = await dbHelper!.getAllTrips();
      final loadedBookings = await dbHelper!.getAllBookings();

      int pending = 0;
      int confirmed = 0;
      int cancelled = 0;

      for (var booking in loadedBookings) {
        switch (booking.status.toLowerCase()) {
          case 'pending':
            pending++;
            break;
          case 'confirmed':
            confirmed++;
            break;
          case 'cancelled':
            cancelled++;
            break;
        }
      }

      setState(() {
        trips = loadedTrips;
        bookings = loadedBookings;
        totalTrips = loadedTrips.length;
        totalBookings = loadedBookings.length;
        pendingBookings = pending;
        confirmedBookings = confirmed;
        cancelledBookings = cancelled;
        isLoading = false;
      });
    } catch (e) {
      print('Error cargando estadísticas: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Statistics",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal[700],
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Statistics Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _loadStatistics();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStatistics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cards de resumen
              _buildSummaryCards(),
              const SizedBox(height: 24),

              // Grafico de barras para los bookings por trip
              const Text(
                "Bookings per Trip",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildBarChart(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Cards de resumen
  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Trips',
            totalTrips.toString(),
            Icons.flight_takeoff,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Total Bookings',
            totalBookings.toString(),
            Icons.book_online,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Gráfico de barras
  Widget _buildBarChart() {
    if (trips.isEmpty || bookings.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    // Contar bookings por trip
    Map<int, int> bookingsPerTrip = {};
    for (var booking in bookings) {
      bookingsPerTrip[booking.tripId] = (bookingsPerTrip[booking.tripId] ?? 0) + 1;
    }

    // Crear barras
    List<BarChartGroupData> barGroups = [];
    int index = 0;
    for (var trip in trips) {
      final count = bookingsPerTrip[trip.id] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: Colors.teal[700],
              width: 20,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        ),
      );
      index++;
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (bookingsPerTrip.values.isEmpty ? 5 : bookingsPerTrip.values.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
          barGroups: barGroups,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= trips.length) return const Text('');
                  final trip = trips[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      trip.location,
                      style: const TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300],
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }
}