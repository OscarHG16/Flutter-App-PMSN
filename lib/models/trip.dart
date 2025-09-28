class Trip {
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
    this.hotelImage
  });
}