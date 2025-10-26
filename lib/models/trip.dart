class Trip {
  final int? id; 
  final String image;
  final String duration;
  final String rating;
  final String title;
  final String location;
  final String reviews;
  final String package;
  final String cost;
  final String description;
  final String? dayTitle;
  final String? hotelImage;

  Trip({
    this.id, 
    required this.image,
    required this.duration,
    required this.rating,
    required this.title,
    required this.location,
    required this.reviews,
    required this.package,
    required this.cost,
    required this.description,
    this.dayTitle,
    this.hotelImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'duration': duration,
      'rating': rating,
      'title': title,
      'location': location,
      'reviews': reviews,
      'package': package,
      'cost': cost,
      'description': description,
      'dayTitle': dayTitle,
      'hotelImage': hotelImage,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      image: map['image'],
      duration: map['duration'],
      rating: map['rating'],
      title: map['title'],
      location: map['location'],
      reviews: map['reviews'],
      package: map['package'],
      cost: map['cost'],
      description: map['description'],
      dayTitle: map['dayTitle'],
      hotelImage: map['hotelImage'],
    );
  }

  Trip copyWith({
    int? id,
    String? image,
    String? duration,
    String? rating,
    String? title,
    String? location,
    String? reviews,
    String? package,
    String? cost,
    String? description,
    String? dayTitle,
    String? hotelImage,
  }) {
    return Trip(
      id: id ?? this.id, 
      image: image ?? this.image,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      location: location ?? this.location,
      reviews: reviews ?? this.reviews,
      package: package ?? this.package,
      cost: cost ?? this.cost,
      description: description ?? this.description,
      dayTitle: dayTitle ?? this.dayTitle,
      hotelImage: hotelImage ?? this.hotelImage,
    );
  }
}