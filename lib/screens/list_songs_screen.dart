import 'package:flutter/material.dart';
import 'package:pmsn20252/firebase/songs_firebase.dart';
import 'package:pmsn20252/screens/song_widget.dart';

class ListSongsScreen extends StatefulWidget {
  const ListSongsScreen({super.key});

  @override
  State<ListSongsScreen> createState() => _ListSongsScreenState();
}

class _ListSongsScreenState extends State<ListSongsScreen> {

  SongsFirebase songsFirebase = SongsFirebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Canciones"
        )
      ),
      body: StreamBuilder(
        stream: songsFirebase.selectAllSongs(), 
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length, 
              itemBuilder: (context, index) {
                return SongWidget(snapshot.data!.docs[index].data() as Map<String, dynamic>);
              },
              );
          }
          else{
            if(snapshot.hasError){
              return Center(
                child: Text(
                  "Something went wrong!"
                ),
              );
            }
            else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
        ),
    );
  }
}