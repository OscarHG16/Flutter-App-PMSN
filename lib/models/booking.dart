class Booking {
  final int? id; 
  final int tripId; 
  final String userName;
  final String userEmail;
  final DateTime bookingDate;
  final DateTime travelDate; 
  final int numberOfPeople;
  final String status; 
  final DateTime createdAt; 

  Booking({
    this.id,
    required this.tripId,
    required this.userName,
    required this.userEmail,
    required this.bookingDate,
    required this.travelDate,
    required this.numberOfPeople,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'userName': userName,
      'userEmail': userEmail,
      'bookingDate': bookingDate.toIso8601String(),
      'travelDate': travelDate.toIso8601String(),
      'numberOfPeople': numberOfPeople,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      tripId: map['tripId'],
      userName: map['userName'],
      userEmail: map['userEmail'],
      bookingDate: DateTime.parse(map['bookingDate']),
      travelDate: DateTime.parse(map['travelDate']),
      numberOfPeople: map['numberOfPeople'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Booking copyWith({
    int? id,
    int? tripId,
    String? userName,
    String? userEmail,
    DateTime? bookingDate,
    DateTime? travelDate,
    int? numberOfPeople,
    String? status,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      bookingDate: bookingDate ?? this.bookingDate,
      travelDate: travelDate ?? this.travelDate,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}