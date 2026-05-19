import 'package:flutter/foundation.dart';
import 'package:finetravel/models/destination.dart';

class MockData {
  static final ValueNotifier<int> destinationsNotifier = ValueNotifier(0);

  static void notifyDestinationsChanged() {
    destinationsNotifier.value++;
  }

  static List<Destination> destinations = [
    Destination(
      id: '1',
      name: 'Ölüdeniz',
      location: 'Fethiye, Türkiye',
      description: 'Ölüdeniz is a small village in Fethiye. It is famous for its Blue Lagoon and paragliding activities from Babadağ mountain.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Paragliding_view_oludeniz_-_panoramio_%282%29.jpg/1280px-Paragliding_view_oludeniz_-_panoramio_%282%29.jpg',
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
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Cappadocia_balloon_trip%2C_Ortahisar_Castle_%2811893715185%29.jpg/1280px-Cappadocia_balloon_trip%2C_Ortahisar_Castle_%2811893715185%29.jpg',
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
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Oia_sunset_-_panoramio_%282%29.jpg/1280px-Oia_sunset_-_panoramio_%282%29.jpg',
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
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Kiyomizu.jpg/1280px-Kiyomizu.jpg',
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
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3d/Amalfi_Coast_%28Italy%2C_October_2020%29_-_75_%2850558355441%29.jpg/1280px-Amalfi_Coast_%28Italy%2C_October_2020%29_-_75_%2850558355441%29.jpg',
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
