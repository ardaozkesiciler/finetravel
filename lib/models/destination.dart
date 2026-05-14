class Destination {
  final String id;
  final String name;
  final String location;
  final String description;
  final String imageUrl;
  final double rating;
  final String price;
  final double? latitude;
  final double? longitude;
  final String workingHours;
  final String entryFee;

  Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imageUrl,
    this.rating = 4.5,
    this.price = '€€',
    this.latitude,
    this.longitude,
    this.workingHours = '09:00 - 18:00',
    this.entryFee = 'Free',
  });
}
