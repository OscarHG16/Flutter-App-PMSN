import 'package:flutter/material.dart';
import 'package:pmsn20252/database/movies_database.dart';

class ListMovies extends StatefulWidget {
  const ListMovies({super.key});

  @override
  State<ListMovies> createState() => _ListMoviesState();
}

class _ListMoviesState extends State<ListMovies> {
  MoviesDatabase? moviesDB;

  @override
  void initState() {
    super.initState();
    moviesDB = MoviesDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Peliculas :)"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/add").then((_) {
                setState(() {}); // Esto forzará la actualización
              });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: moviesDB!.SELECT(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something was wrong!'));
          } else {
            if (snapshot.hasData) {
              return snapshot.data!.isNotEmpty
                  ? ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final objM = snapshot
                            .data![index]; // aqui recuperamos el objeto de la lista por decirlo asi obtenemos el registro donde el mismo itembuilder maneja un index para saber donde se encuentra y en que elemnto. Creamos un objeto para solo mandalo a llamar mas abajo
                        return Container(
                          height: 100,
                          color: Colors.black,
                          child: Column(
                            children: [
                              Text(objM.nameMovie!),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        Navigator.pushNamed(
                                          context,
                                          "/add",
                                          arguments: objM,
                                        ).then(
                                          (value) => setState(() {}),
                                        ), //Para mandar datos entre pantallas se usa el arguments y mandar el objeto
                                    icon: Icon(Icons.edit),
                                  ),
                                  Expanded(child: Container()),
                                  IconButton(
                                    onPressed: () async {
                                      return showDialog(
                                        context: context,
                                        builder: (context) =>
                                            _buildAlertDialog(objM.idMovie!),
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(child: Text('No existen registros'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }

  Widget _buildAlertDialog(int idMovie) {
    return AlertDialog(
      title: Text("Atencion :)"),
      content: Text("¿Estas seguro de eliminar este registro?"),
      actions: [
        //Para IOs es tener cuidado con los botones y politicas ya que pide sombreado como boton
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar", style: TextStyle(color: Colors.blue),),
        ),
        TextButton(
          onPressed: () {
            moviesDB!.DELETE("tblMovies", idMovie).then((value) {
              String msj = "";
              if (value > 0) {
                msj = "Registro borrado exitosamente";
                setState(() {});
              } else {
                msj = "No se pudo borrar el registro";
              }
              final snackBar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
            });
          },
          child: Text("Aceptar", style: TextStyle(color: Colors.red),),
        ),
      ],
    );
  }
}
