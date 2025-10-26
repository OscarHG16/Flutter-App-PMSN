import 'package:flutter/material.dart';
import 'package:pmsn20252/models/api_movie_dao.dart';

class ItemMovieWidget extends StatelessWidget {
  ItemMovieWidget({super.key, required this.apiMovieDao}); //Es obligatorio

   ApiMovieDao apiMovieDao;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: FadeInImage(
        placeholder: AssetImage('assets/loading1.gif'),   
        image:  NetworkImage('https://image.tmdb.org/t/p/w500/${apiMovieDao.posterPath}') //Completamos la URL ya que en la api la parte de "posterPath" solo vienen la ultima parte de la ruta y con eso nos iba a dar error asi que le agregamos la URL para que este completa
        ),
    );
  }
}