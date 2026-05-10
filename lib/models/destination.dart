class Destination {
  final String id;
  final String name;
  final String location;
  final String description;
  final String imageUrl;
  final double rating;
  final String price;

  Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imageUrl,
    this.rating = 4.5,
    this.price = '€€',
  });
}
