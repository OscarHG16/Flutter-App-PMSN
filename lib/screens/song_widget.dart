import 'package:flutter/material.dart';

class SongWidget extends StatefulWidget {
  SongWidget(this.song, {super.key});
  final Map<String, dynamic> song;
  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey,
      ),
      child: Row(
        children: [
          FadeInImage(
            placeholder: AssetImage('assets/placeholder.png'),
            fadeInDuration: Duration(seconds: 4),
            image: NetworkImage(widget.song['cover']),
          ),
        ],
      ),
    );
  }
}
