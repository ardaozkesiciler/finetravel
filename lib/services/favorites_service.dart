import 'package:finetravel/models/destination.dart';
import 'package:flutter/material.dart';

class FavoritesService extends ChangeNotifier {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  final List<Destination> _favorites = [];

  List<Destination> get favorites => List.unmodifiable(_favorites);

  void add(Destination destination) {
    if (!_favorites.any((d) => d.id == destination.id)) {
      _favorites.add(destination);
      notifyListeners();
    }
  }

  void remove(String id) {
    _favorites.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((d) => d.id == id);
  }
}
