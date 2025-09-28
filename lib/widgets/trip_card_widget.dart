import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String imageUrl;
  final String duration;
  final String rating;
  final String title;
  final VoidCallback? onTap;

  const TripCard({
    super.key,
    required this.imageUrl,
    required this.duration,
    required this.rating,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Para que el efecto ripple no tenga fondo
      child: InkWell( //Inkwell se usa para el efecto ripple (animacion de onda al momento del toque), donde detecta el toque
        onTap: onTap, //Por medio de este onTap nos concetamos al campo que definimos en el constructor para que al ser disparado se ejecute la funcion en la interfaz que definimos que seria pasar a la pantalla de los detalles
        borderRadius: BorderRadius.circular(20), //Solo hace que el efecto tenga las esquinas redondeadas
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
              child: Row(
                children: [
                  Text(
                    duration,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(), //Empuja a la derecha el rating
                  Icon(Icons.star, color: Colors.yellow[700], size: 16),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
