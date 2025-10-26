import 'package:flutter/material.dart';
import 'package:pmsn20252/database/database_helper.dart';
import 'package:pmsn20252/models/booking.dart';
import 'package:pmsn20252/models/trip.dart';
import 'package:intl/intl.dart';

class AddBookingScreen extends StatefulWidget {
  final Booking? booking;

  const AddBookingScreen({super.key, this.booking});

  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  DatabaseHelper? dbHelper;
  TextEditingController conUserName = TextEditingController();
  TextEditingController conUserEmail = TextEditingController();
  TextEditingController conNumberOfPeople = TextEditingController();

  int? selectedTripId;
  String? selectedTripTitle;
  DateTime? travelDate;
  String selectedStatus = 'pending';

  List<Trip> availableTrips = [];

  final List<String> statusOptions = ['pending', 'confirmed', 'cancelled'];

  bool isEditing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _loadTrips();

    if (widget.booking != null) {
      isEditing = true;
      print('Modo editar - Booking ID: ${widget.booking!.id}');

      // Prellenar campos
      conUserName.text = widget.booking!.userName;
      conUserEmail.text = widget.booking!.userEmail;
      conNumberOfPeople.text = widget.booking!.numberOfPeople.toString();
      selectedTripId = widget.booking!.tripId;
      travelDate = widget.booking!.travelDate;
      selectedStatus = widget.booking!.status;
    } else {
      print('Modo agregar - Nueva booking');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is int && !isEditing) {
      setState(() {
        selectedTripId = args;
        print('Trip preseleccionado con ID: $selectedTripId');
      });
    }
  }

  Future<void> _loadTrips() async {
    try {
      final trips = await dbHelper!.getAllTrips();
      setState(() {
        availableTrips = trips;
        isLoading = false;

        // Si estamos editando, buscar el título del trip seleccionado
        if (isEditing && selectedTripId != null) {
          final trip = trips.firstWhere((t) => t.id == selectedTripId);
          selectedTripTitle = trip.title;
        }
      });
      print('Trips disponibles: ${trips.length}');
    } catch (e) {
      print('Error cargando trips: $e');
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
          title: const Text("Loading..."),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Booking" : "Add New Booking",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: availableTrips.isEmpty
          ? _buildNoTripsMessage()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Selector de Trip
                  _buildTripSelector(),
                  const SizedBox(height: 16),

                  // Nombre del usuario
                  _buildTextField(
                    controller: conUserName,
                    label: "Guest Name *",
                    hint: "e.g., John Doe",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),

                  // Email del usuario
                  _buildTextField(
                    controller: conUserEmail,
                    label: "Email *",
                    hint: "e.g., john@example.com",
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Selector de fecha de viaje
                  _buildDateSelector(),
                  const SizedBox(height: 16),

                  // Número de personas
                  _buildTextField(
                    controller: conNumberOfPeople,
                    label: "Number of Travelers *",
                    hint: "e.g., 2",
                    icon: Icons.people,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Selector de estado
                  _buildStatusSelector(),
                  const SizedBox(height: 30),

                  // Botón guardar
                  ElevatedButton(
                    onPressed: _saveBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(isEditing ? Icons.update : Icons.save),
                        const SizedBox(width: 8),
                        Text(
                          isEditing ? "UPDATE BOOKING" : "SAVE BOOKING",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNoTripsMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 80,
              color: Colors.orange[700],
            ),
            const SizedBox(height: 20),
            const Text(
              'No Trips Available',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You need to add trips before creating bookings.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Icon(Icons.flight_takeoff, color: Colors.green[700]),
                const SizedBox(width: 8),
                const Text(
                  'Select Trip *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: selectedTripId,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Choose a trip...'),
              ),
              items: availableTrips.map((trip) {
                return DropdownMenuItem<int>(
                  value: trip.id,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          trip.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${trip.location} - ${trip.duration} - \$${trip.cost}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTripId = value;
                  if (value != null) {
                    final trip = availableTrips.firstWhere((t) => t.id == value);
                    selectedTripTitle = trip.title;
                    print('Trip seleccionado: $selectedTripTitle');
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy');

    return InkWell(
      onTap: () => _selectTravelDate(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.green[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Travel Date *',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    travelDate != null
                        ? dateFormat.format(travelDate!)
                        : 'Tap to select date',
                    style: TextStyle(
                      color: travelDate != null
                          ? Colors.black87
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  // Selector de estado
  Widget _buildStatusSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green[700]),
                const SizedBox(width: 8),
                const Text(
                  'Booking Status *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedStatus,
              items: statusOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getStatusColor(status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(status.toUpperCase()),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                  print('Estado seleccionado: $selectedStatus');
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget para campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.green[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.green[700]!,
            width: 2,
          ),
        ),
      ),
    );
  }

  // Función para seleccionar fecha de viaje
  Future<void> _selectTravelDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: travelDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)), // 2 años
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[700]!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != travelDate) {
      setState(() {
        travelDate = picked;
        print('Fecha seleccionada: ${DateFormat('yyyy-MM-dd').format(picked)}'); //Dmamos formato a la fecha
      });
    }
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

  void _saveBooking() async {
    print('Guardando booking');

    // Validaciones
    if (selectedTripId == null) {
      _showError('Please select a trip');
      return;
    }

    if (conUserName.text.isEmpty) {
      _showError('Please enter guest name');
      return;
    }

    if (conUserEmail.text.isEmpty) {
      _showError('Please enter email');
      return;
    }

    if (travelDate == null) {
      _showError('Please select travel date');
      return;
    }

    if (conNumberOfPeople.text.isEmpty) {
      _showError('Please enter number of travelers');
      return;
    }

    final numberOfPeople = int.tryParse(conNumberOfPeople.text);
    if (numberOfPeople == null || numberOfPeople <= 0) {
      _showError('Please enter a valid number of travelers');
      return;
    }

    try {
      if (isEditing) {
        print('Actualizando booking ID: ${widget.booking!.id}');

        final updatedBooking = Booking(
          id: widget.booking!.id,
          tripId: selectedTripId!,
          userName: conUserName.text,
          userEmail: conUserEmail.text,
          bookingDate: widget.booking!.bookingDate, // Mantener fecha original
          travelDate: travelDate!,
          numberOfPeople: numberOfPeople,
          status: selectedStatus,
          createdAt: widget.booking!.createdAt, // Mantener createdAt original
        );

        final result = await dbHelper!.updateBooking(updatedBooking);

        if (result > 0) {
          print('Booking actualizado correctamente');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        }
      } else {
        print('Insertando nuevo booking');

        final now = DateTime.now();
        final newBooking = Booking(
          tripId: selectedTripId!,
          userName: conUserName.text,
          userEmail: conUserEmail.text,
          bookingDate: now,
          travelDate: travelDate!,
          numberOfPeople: numberOfPeople,
          status: selectedStatus,
          createdAt: now,
        );

        final result = await dbHelper!.insertBooking(newBooking);

        if (result > 0) {
          print('Booking insertado correctamente con ID: $result');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        }
      }
    } catch (e) {
      print('Error al guardar booking: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  void dispose() {
    conUserName.dispose();
    conUserEmail.dispose();
    conNumberOfPeople.dispose();
    super.dispose();
  }
}