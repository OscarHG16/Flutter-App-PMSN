import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pmsn20252/models/trip.dart';
import 'package:pmsn20252/models/booking.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  
  static Database? _database; //Esta variable guarda la instacioa de la base de datos

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expedia_app.db');
    
    return await openDatabase(
      path,
      version: 1, // Versión de la BD 
      onCreate: _onCreate, 
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trips(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image TEXT NOT NULL,
        duration TEXT NOT NULL,
        rating TEXT NOT NULL,
        title TEXT NOT NULL,
        location TEXT NOT NULL,
        reviews TEXT NOT NULL,
        package TEXT NOT NULL,
        cost TEXT NOT NULL,
        description TEXT NOT NULL,
        dayTitle TEXT,
        hotelImage TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE bookings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tripId INTEGER NOT NULL,
        userName TEXT NOT NULL,
        userEmail TEXT NOT NULL,
        bookingDate TEXT NOT NULL,
        travelDate TEXT NOT NULL,
        numberOfPeople INTEGER NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (tripId) REFERENCES trips (id) ON DELETE CASCADE
      )
    ''');
  }

  
  Future<int> INSERT(String table, Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> SELECT(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> UPDATE(String table, Map<String, dynamic> row) async {
    final db = await database;
    int id = row['id'];
    return await db.update(
      table,
      row,
      where: 'id = ?',
      whereArgs: [id], 
    );
  }

  Future<int> DELETE(String table, int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertTrip(Trip trip) async {
    return await INSERT('trips', trip.toMap());
  }

  Future<List<Trip>> getAllTrips() async {
    final maps = await SELECT('trips');
    return maps.map((map) => Trip.fromMap(map)).toList();
  }

  Future<Trip?> getTripById(int id) async {
    final db = await database;
    final maps = await db.query(
      'trips',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Trip.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTrip(Trip trip) async {
    return await UPDATE('trips', trip.toMap());
  }

  Future<int> deleteTrip(int id) async {
    return await DELETE('trips', id);
  }
  
  Future<int> insertBooking(Booking booking) async {
    return await INSERT('bookings', booking.toMap());
  }

  Future<List<Booking>> getAllBookings() async {
    final maps = await SELECT('bookings');
    return maps.map((map) => Booking.fromMap(map)).toList();
  }

  Future<List<Booking>> getBookingsByTrip(int tripId) async {
    final db = await database;
    final maps = await db.query(
      'bookings',
      where: 'tripId = ?',
      whereArgs: [tripId],
    );
    return maps.map((map) => Booking.fromMap(map)).toList();
  }

  Future<List<Booking>> getBookingsByDate(DateTime date) async {
    final db = await database;
    String dateStr = date.toIso8601String().split('T')[0];
    final maps = await db.query(
      'bookings',
      where: 'travelDate LIKE ?',
      whereArgs: ['$dateStr%'],
    );
    return maps.map((map) => Booking.fromMap(map)).toList();
  }

  Future<int> updateBooking(Booking booking) async {
    return await UPDATE('bookings', booking.toMap());
  }

  Future<int> deleteBooking(int id) async {
    return await DELETE('bookings', id);
  }

  Future<List<Map<String, dynamic>>> getBookingsWithTripInfo() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        bookings.*,
        trips.title as tripTitle,
        trips.image as tripImage,
        trips.location as tripLocation,
        trips.duration as tripDuration
      FROM bookings
      INNER JOIN trips ON bookings.tripId = trips.id
      ORDER BY bookings.travelDate
    ''');
  }

  Future<bool> tripHasBookings(int tripId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM bookings WHERE tripId = ?',
      [tripId]
    );
    int count = result.first['count'] as int;
    return count > 0;
  }

  Future<void> insertInitialTrips() async {
    final trips = await getAllTrips();
    
    if (trips.isEmpty) {
      
      await insertTrip(Trip(
        image: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=60',
        duration: '7 Days',
        rating: '4.8',
        title: 'How to get around Thailand on the cheap budget in 2021',
        location: 'Thailand',
        reviews: '2.5k reviews',
        package: '2 Person',
        cost: '600',
        description: 'Bangkok might remind many Indians of Mumbai with its bustling city life speckled with traditions and culture. The traffic might be a stark reminder too!',
        dayTitle: "DAY 01 - BANGKOK",
        hotelImage: "https://www.hilton.com/im/en/BKKASHI/22392611/building.jpg?impolicy=crop&cw=5000&ch=2799&gravity=NorthWest&xposition=0&yposition=265&rw=768&rh=430",
      ));

      await insertTrip(Trip(
        image: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=800&q=60',
        duration: '5 Days',
        rating: '4.6',
        title: 'Tropical Weekend',
        location: 'Hawaii',
        reviews: '1.8k reviews',
        package: '2 Person',
        cost: '800',
        description: 'Enjoy the tropical vibes and sandy beaches for a relaxing getaway.',
        dayTitle: "DAY 01 - HONOLULU",
        hotelImage: "https://media-cdn.tripadvisor.com/media/photo-s/1a/24/db/3d/elevated-private-cabanas.jpg"
      ));

      await insertTrip(Trip(
        image: 'https://images.unsplash.com/photo-1526772662000-3f88f10405ff?auto=format&fit=crop&w=800&q=60',
        duration: '4 Days',
        rating: '4.7',
        title: 'City break special',
        location: 'New York',
        reviews: '3.1k reviews',
        package: '1 Person',
        cost: '500',
        description: 'Explore the big city life with skyscrapers, culture, and endless activities.',
        dayTitle: "DAY 01 - QUEENS",
        hotelImage: "https://enneadweb.s3.amazonaws.com/work-images/0417_Standard/_md/0417_Standard_hero4_dusk.jpg"
      ));
      
      print('Datos iniciales insertados correctamente');
    } else {
      print('ℹYa existen datos en la BD');
    }
  }
}