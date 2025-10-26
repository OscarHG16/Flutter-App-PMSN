import 'package:flutter/material.dart';
import 'package:pmsn20252/services/api_movies.dart';
import 'package:pmsn20252/widgets/item_movie_widget.dart';

class ListApiMovies extends StatefulWidget {
  const ListApiMovies({super.key});

  @override
  State<ListApiMovies> createState() => _ListApiMoviesState();
}

class _ListApiMoviesState extends State<ListApiMovies> {

  ApiMovies? apiMovies = ApiMovies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Api Movies"),),
      body: FutureBuilder(
        future: apiMovies!.getMovies(), 
        builder: (context, snapshot){
          if(snapshot.hasData){
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2 
                ), 
              itemBuilder: (context, index){
                return ItemMovieWidget(apiMovieDao: snapshot.data![index]);
              }
              );
          }else{
            if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()),);
            }else{
              return const Center(child: CircularProgressIndicator(),);
            }
          }
        }
        ),
    );
  }
}