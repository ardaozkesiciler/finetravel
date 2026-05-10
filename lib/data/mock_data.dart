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
    ),
    Destination(
      id: '2',
      name: 'Cappadocia',
      location: 'Nevşehir, Türkiye',
      description: 'Known for its unique "fairy chimneys," cave dwellings, and sunrise hot air balloon rides over the surreal landscape.',
      imageUrl: 'https://images.unsplash.com/photo-1541185933-ef5d8ed016c2?q=80&w=1000',
      rating: 4.8,
      price: '₺₺₺₺',
    ),
    Destination(
      id: '3',
      name: 'Santorini',
      location: 'Cyclades, Greece',
      description: 'Famous for its stunning sunsets, white-washed buildings with blue domes, and breathtaking views of the Aegean Sea.',
      imageUrl: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?q=80&w=1000',
      rating: 4.7,
      price: '€€€',
    ),
    Destination(
      id: '4',
      name: 'Kyoto',
      location: 'Kansai, Japan',
      description: 'The cultural heart of Japan, featuring thousands of Buddhist temples, Shinto shrines, and beautiful Zen gardens.',
      imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=1000',
      rating: 4.9,
      price: '¥¥¥',
    ),
    Destination(
      id: '5',
      name: 'Amalfi Coast',
      location: 'Salerno, Italy',
      description: 'A 50-kilometer stretch of coastline along the southern edge of Italy’s Sorrentine Peninsula, famous for its vertical towns.',
      imageUrl: 'https://images.unsplash.com/photo-1633321088355-d0f81134ca3b?q=80&w=1000',
      rating: 4.6,
      price: '€€€€',
    ),
  ];

  static List<Destination> favorites = [
    destinations[0],
    destinations[2],
  ];
}
