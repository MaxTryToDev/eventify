import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

/// Event service for HTTP requests
class EventService {
  static const String baseUrl = 'https://app.ticketmaster.com/discovery/v2/events.json';
  static const String apiKey = 'TwCKnl5Y8ycdiUsGL8jmAJiDqfhBxMpm';
  static const String countryCode = 'US';
  //https://app.ticketmaster.com/discovery/v2/events.json?countryCode=FR&apikey=TwCKnl5Y8ycdiUsGL8jmAJiDqfhBxMpm

  /// Perform GET request
  Future<List<Event>> getEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?countryCode=$countryCode&apikey=$apiKey')
      );

      if (response.statusCode == 200) {
        // 1. Décoder la réponse en un Map (objet)
        final Map<String, dynamic> data = json.decode(response.body);

        // 2. Vérifier si la clé '_embedded' et 'events' existent
        if (data.containsKey('_embedded') && data['_embedded'].containsKey('events')) {
          // 3. Extraire la liste des événements
          final List<dynamic> eventList = data['_embedded']['events'];

          // 4. Mapper la liste JSON à une liste d'objets Event
          return eventList.map((json) => Event.fromJson(json)).toList();
        } else {
          // Si la clé n'existe pas, cela signifie qu'il n'y a pas d'événements
          return []; // Retourner une liste vide
        }
      } else {
        throw Exception(
            'Erreur ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}