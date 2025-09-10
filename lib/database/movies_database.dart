import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MoviesDatabase {
  static final nameDB = "MOVIESDB";
  static final versionDB = 1;

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null)
      return _database; //Verifica que la base de datos no sea nula
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB); //"$folder/$nameDB";
    return openDatabase(
      pathDB,
      version: versionDB,
      onCreate: createTables //El onCreate sirve para crear las tablas y lo ponemos en un metodo porque es mas facil de leer y es buena practica para no tener toda la creacion de tablas en un solo lugar
    );
  }

  Future<void> createTables(Database db, int version) {
    String query = '''
    CREATE TABLE tblMovies(
    idMovie INTEGER PRIMARY KEY,
    nameMovie VARCHAR(50),
    time CHAR(3),
    dateRelease CHAR(10)
    )
  ''';
  return db.execute(query);
  }

  Future <int> INSERT(String table, Map<String, dynamic> data) async {
    var con = await database; //recupera la conexion a la base de datos
    return con!.insert(table, data); //inserta en la tabla los datos y el ""!"" es para decirle que no es nulo osea que si o si estamos seguros que no es nulo
  }
  Future<int> UPDATE(String table, Map<String, dynamic> data) async{ //colocamos "Future<int>" ´prque devuelve la cantidad de filas afectadas
    var con = await database;
    return con!.update(table, data, where: 'idMovie = ?', whereArgs: [data['idMovie']]); // el 'idMovie = ?' es una consulta parametrizada.
  }
  Future<int> DELETE(String table, int id) async {
    var con =await database;
    return con!.delete(table, where: 'idMovie = ?', whereArgs: [id]); //el whereArgs es para pasarle el valor del idMovie que queremos eliminar
  }
  SELECT(){}
}
