class Product {
  final String id;
  final String image;
  final String category;
  final String name;
  final bool isFavorite;

  Product({
    String? id, 
    required this.image,
    required this.category,
    required this.name,
    this.isFavorite = false,
  }) : id = id ?? ''; //Le damos un valor por defecto si es null
}