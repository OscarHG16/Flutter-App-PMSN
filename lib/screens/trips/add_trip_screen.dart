import 'package:flutter/material.dart';
import 'package:pmsn20252/database/database_helper.dart';
import 'package:pmsn20252/models/trip.dart';

class AddTripScreen extends StatefulWidget {
  final Trip? trip;
  
  const AddTripScreen({super.key, this.trip});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  DatabaseHelper? dbHelper;
  
  //Controladores para cada campo del formulario
  TextEditingController conImage = TextEditingController();
  TextEditingController conDuration = TextEditingController();
  TextEditingController conRating = TextEditingController();
  TextEditingController conTitle = TextEditingController();
  TextEditingController conLocation = TextEditingController();
  TextEditingController conReviews = TextEditingController();
  TextEditingController conPackage = TextEditingController();
  TextEditingController conCost = TextEditingController();
  TextEditingController conDescription = TextEditingController();
  TextEditingController conDayTitle = TextEditingController();
  TextEditingController conHotelImage = TextEditingController();
  
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    
    if (widget.trip != null) {
      isEditing = true;
      
      // Prellenar los campos con los datos del trip
      conImage.text = widget.trip!.image;
      conDuration.text = widget.trip!.duration;
      conRating.text = widget.trip!.rating;
      conTitle.text = widget.trip!.title;
      conLocation.text = widget.trip!.location;
      conReviews.text = widget.trip!.reviews;
      conPackage.text = widget.trip!.package;
      conCost.text = widget.trip!.cost;
      conDescription.text = widget.trip!.description;
      conDayTitle.text = widget.trip!.dayTitle ?? '';
      conHotelImage.text = widget.trip!.hotelImage ?? '';
    } else {
      print('Modo Agegar - Nuevo trip');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Trip" : "Add New Trip",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TÍTULO
            _buildTextField(
              controller: conTitle,
              label: "Trip Title *",
              hint: "e.g., Match Barcelona",
              icon: Icons.title,
            ),
            const SizedBox(height: 16),
            
            // UBICACIÓN
            _buildTextField(
              controller: conLocation,
              label: "Location *",
              hint: "e.g., Thailand",
              icon: Icons.location_on,
            ),
            const SizedBox(height: 16),
            
            // DURACIÓN
            _buildTextField(
              controller: conDuration,
              label: "Duration *",
              hint: "e.g., 7 Days",
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            
            // RATING
            _buildTextField(
              controller: conRating,
              label: "Rating *",
              hint: "e.g., 4.8",
              icon: Icons.star,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            // REVIEWS
            _buildTextField(
              controller: conReviews,
              label: "Reviews *",
              hint: "e.g., 2.5k reviews",
              icon: Icons.rate_review,
            ),
            const SizedBox(height: 16),
            
            // PAQUETE
            _buildTextField(
              controller: conPackage,
              label: "Package *",
              hint: "e.g., 2 Person",
              icon: Icons.people,
            ),
            const SizedBox(height: 16),
            
            // COSTO
            _buildTextField(
              controller: conCost,
              label: "Cost (USD) *",
              hint: "e.g., 600",
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            // DESCRIPCIÓN
            _buildTextField(
              controller: conDescription,
              label: "Description *",
              hint: "Brief description of the trip",
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // URL DE IMAGEN
            _buildTextField(
              controller: conImage,
              label: "Image URL *",
              hint: "https://example.com/image.jpg",
              icon: Icons.image,
            ),
            const SizedBox(height: 16),
            
            // TÍTULO DEL DÍA opcional
            _buildTextField(
              controller: conDayTitle,
              label: "Day Title (Optional)",
              hint: "e.g., DAY 01 - BANGKOK",
              icon: Icons.event_note,
            ),
            const SizedBox(height: 16),
            
            // URL DE HOTEL opcional
            _buildTextField(
              controller: conHotelImage,
              label: "Hotel Image URL (Optional)",
              hint: "https://example.com/hotel.jpg",
              icon: Icons.hotel,
            ),
            const SizedBox(height: 30),
            
            // BOTÓN GUARDAR
            ElevatedButton(
              onPressed: _saveTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
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
                    isEditing ? "UPDATE TRIP" : "SAVE TRIP",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget para crear campos de texto por si queremos mas
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF2563EB)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF2563EB),
            width: 2,
          ),
        ),
      ),
    );
  }

  // Función para guardar el trip
  void _saveTrip() async {
    print('Guardando ttip');
    
    // Validar que los campos obligatorios no estén vacíos
    if (conTitle.text.isEmpty ||
        conLocation.text.isEmpty ||
        conDuration.text.isEmpty ||
        conRating.text.isEmpty ||
        conReviews.text.isEmpty ||
        conPackage.text.isEmpty ||
        conCost.text.isEmpty ||
        conDescription.text.isEmpty ||
        conImage.text.isEmpty) {
      print('Campos obligatorios vacíos');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellene todos los campos obligatorios (*)'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      if (isEditing) {
        // MODO EDITAR
        print('Actualizando trip ID: ${widget.trip!.id}');
        
        // Creamos un trip actualizado con los nuevos datos
        final updatedTrip = Trip(
          id: widget.trip!.id, // Mantenemos el mismo ID
          image: conImage.text,
          duration: conDuration.text,
          rating: conRating.text,
          title: conTitle.text,
          location: conLocation.text,
          reviews: conReviews.text,
          package: conPackage.text,
          cost: conCost.text,
          description: conDescription.text,
          dayTitle: conDayTitle.text.isEmpty ? null : conDayTitle.text,
          hotelImage: conHotelImage.text.isEmpty ? null : conHotelImage.text,
        );
        
        // Actualizamos en la BD
        final result = await dbHelper!.updateTrip(updatedTrip);
        
        if (result > 0) {
          print('Trip actualizado correctamente');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Trip updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context); // Regresar a la lista
          }
        }
      } else {
        // MODO AGREGAR
        print('Insertando nuevo trip');
        
        // Creamos un trip nuevo
        final newTrip = Trip(
          image: conImage.text,
          duration: conDuration.text,
          rating: conRating.text,
          title: conTitle.text,
          location: conLocation.text,
          reviews: conReviews.text,
          package: conPackage.text,
          cost: conCost.text,
          description: conDescription.text,
          dayTitle: conDayTitle.text.isEmpty ? null : conDayTitle.text,
          hotelImage: conHotelImage.text.isEmpty ? null : conHotelImage.text,
        );
        
        // Insertamos en la BD
        final result = await dbHelper!.insertTrip(newTrip);
        
        if (result > 0) {
          print('Trip insertado correctamente con ID: $result');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Trip added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context); // Regresar a la lista
          }
        }
      }
    } catch (e) {
      print('Error al guardar trip: $e');
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

  @override
  void dispose() {
    conImage.dispose();
    conDuration.dispose();
    conRating.dispose();
    conTitle.dispose();
    conLocation.dispose();
    conReviews.dispose();
    conPackage.dispose();
    conCost.dispose();
    conDescription.dispose();
    conDayTitle.dispose();
    conHotelImage.dispose();
    super.dispose();
  }
}