import 'package:flutter/material.dart';
import '../models/event.dart';

class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final List<Event> _favoriteEvents = [];

  List<Event> get favorites => _favoriteEvents;

  bool isFavorite(Event event) {
    return _favoriteEvents.any((e) => e.id == event.id);
  }

  void toggleFavorite(Event event) {
    if (isFavorite(event)) {
      _favoriteEvents.removeWhere((e) => e.id == event.id);
    } else {
      _favoriteEvents.add(event);
    }
    notifyListeners();
  }
}
