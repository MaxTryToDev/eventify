import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/event.dart';

class LocalFavoritesService {
  static const String _favoritesPrefix = 'favorites_';

  Future<void> addFavorite(String userId, Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites(userId);
    
    if (!favorites.any((e) => e.id == event.id)) {
      favorites.add(event);
      final favoritesJson = favorites.map((e) => e.toJson()).toList();
      await prefs.setString('$_favoritesPrefix$userId', jsonEncode(favoritesJson));
    }
  }

  Future<void> removeFavorite(String userId, String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites(userId);
    
    favorites.removeWhere((e) => e.id == eventId);
    final favoritesJson = favorites.map((e) => e.toJson()).toList();
    await prefs.setString('$_favoritesPrefix$userId', jsonEncode(favoritesJson));
  }

  Future<List<Event>> getFavorites(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesData = prefs.getString('$_favoritesPrefix$userId');
    
    if (favoritesData == null) return [];
    
    final List<dynamic> favoritesJson = jsonDecode(favoritesData);
    return favoritesJson.map((json) => Event.fromJson(json)).toList();
  }

  Future<bool> isFavorite(String userId, String eventId) async {
    final favorites = await getFavorites(userId);
    return favorites.any((e) => e.id == eventId);
  }
}