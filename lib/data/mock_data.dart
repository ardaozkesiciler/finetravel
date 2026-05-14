import 'package:finetravel/models/destination.dart';

class MockData {
  static List<Destination> destinations = [
    Destination(
      id: '1',
      name: 'Ölüdeniz',
      location: 'Fethiye, Türkiye',
      description: 'Ölüdeniz is a small village in Fethiye. It is famous for its Blue Lagoon and paragliding activities from Babadağ mountain.',
      imageUrl: 'https://images.unsplash.com/photo-1542051841857-5f90071e7989?q=80&w=1000',
      rating: 4.9,
      price: '₺₺₺',
      latitude: 36.5492,
      longitude: 29.1264,
      workingHours: '08:00 - 20:00',
      entryFee: '₺50 (Entrance)',
    ),
    Destination(
      id: '2',
      name: 'Cappadocia',
      location: 'Nevşehir, Türkiye',
      description: 'Known for its unique "fairy chimneys," cave dwellings, and sunrise hot air balloon rides over the surreal landscape.',
      imageUrl: 'https://images.unsplash.com/photo-1541185933-ef5d8ed016c2?q=80&w=1000',
      rating: 4.8,
      price: '₺₺₺₺',
      latitude: 38.6431,
      longitude: 34.8303,
      workingHours: '24/7 Open',
      entryFee: 'Free (Museums ₺200+)',
    ),
    Destination(
      id: '3',
      name: 'Santorini',
      location: 'Cyclades, Greece',
      description: 'Famous for its stunning sunsets, white-washed buildings with blue domes, and breathtaking views of the Aegean Sea.',
      imageUrl: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?q=80&w=1000',
      rating: 4.7,
      price: '€€€',
      latitude: 36.3932,
      longitude: 25.4615,
      workingHours: '24/7 Open',
      entryFee: 'Free',
    ),
    Destination(
      id: '4',
      name: 'Kyoto',
      location: 'Kansai, Japan',
      description: 'The cultural heart of Japan, featuring thousands of Buddhist temples, Shinto shrines, and beautiful Zen gardens.',
      imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=1000',
      rating: 4.9,
      price: '¥¥¥',
      latitude: 35.0116,
      longitude: 135.7681,
      workingHours: '09:00 - 17:00',
      entryFee: '¥500 (Temple Entry)',
    ),
    Destination(
      id: '5',
      name: 'Amalfi Coast',
      location: 'Salerno, Italy',
      description: 'A 50-kilometer stretch of coastline along the southern edge of Italy’s Sorrentine Peninsula, famous for its vertical towns.',
      imageUrl: 'https://images.unsplash.com/photo-1633321088355-d0f81134ca3b?q=80&w=1000',
      rating: 4.4,
      price: '€€€€',
      latitude: 40.6333,
      longitude: 14.6033,
      workingHours: '24/7 Open',
      entryFee: 'Free',
    ),
  ];

  static List<Destination> favorites = [
    destinations[0],
    destinations[2],
  ];

  static List<Destination> travelHistory = [
    destinations[1], // Cappadocia
    destinations[3], // Kyoto
    destinations[4], // Amalfi Coast
  ];
}
