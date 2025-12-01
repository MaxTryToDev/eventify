import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/event.dart';
import '../models/country.dart';
import '../services/event_service.dart';
import 'event_detail_view.dart';
import 'widgets/event_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final EventService _eventService = EventService();
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  bool _isLoading = true;
  bool _showList = false;
  Country? _selectedCountry;
  
  final List<Country> _availableCountries = [
    Country(code: 'US', name: 'États-Unis', latitude: 39.8283, longitude: -98.5795),
    Country(code: 'CA', name: 'Canada', latitude: 56.1304, longitude: -106.3468),
    Country(code: 'MX', name: 'Mexique', latitude: 23.6345, longitude: -102.5528),
    Country(code: 'GB', name: 'Royaume-Uni', latitude: 55.3781, longitude: -3.4360),
    Country(code: 'IE', name: 'Irlande', latitude: 53.4129, longitude: -8.2439),
    Country(code: 'DE', name: 'Allemagne', latitude: 51.1657, longitude: 10.4515),
    Country(code: 'FR', name: 'France', latitude: 46.2276, longitude: 2.2137),
    Country(code: 'ES', name: 'Espagne', latitude: 40.4637, longitude: -3.7492),
    Country(code: 'IT', name: 'Italie', latitude: 41.8719, longitude: 12.5674),
    Country(code: 'NL', name: 'Pays-Bas', latitude: 52.1326, longitude: 5.2913),
    Country(code: 'BE', name: 'Belgique', latitude: 50.5039, longitude: 4.4699),
    Country(code: 'AU', name: 'Australie', latitude: -25.2744, longitude: 133.7751),
    Country(code: 'NZ', name: 'Nouvelle-Zélande', latitude: -40.9006, longitude: 174.8860),
  ];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents([String? countryCode]) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final events = await _eventService.getEvents(countryCode ?? 'US');
      setState(() {
        _events = events;
        _filteredEvents = events;
        _isLoading = false;
      });
      
      // Déplacer la carte vers le pays sélectionné
      if (_selectedCountry != null && !_showList) {
        await Future.delayed(const Duration(milliseconds: 200));
        _mapController.move(LatLng(_selectedCountry!.latitude, _selectedCountry!.longitude), 6);
      } else {
        _moveToFilteredEvents();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterEvents([String? query]) {
    setState(() {
      var filtered = _events;
      
      final searchQuery = query ?? _searchController.text;
      if (searchQuery.isNotEmpty) {
        filtered = filtered.where((event) {
          return event.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                 event.venue.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                 event.venue.city.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      }
      
      _filteredEvents = filtered;
      _moveToFilteredEvents();
    });
  }

  void _moveToFilteredEvents() {
    if (_filteredEvents.isNotEmpty && !_showList) {
      final eventsWithCoords = _filteredEvents.where((e) => e.venue.latitude != null && e.venue.longitude != null).toList();
      if (eventsWithCoords.isNotEmpty) {
        if (eventsWithCoords.length == 1) {
          _mapController.move(LatLng(eventsWithCoords.first.venue.latitude!, eventsWithCoords.first.venue.longitude!), 14);
        } else {
          final bounds = _calculateBounds(eventsWithCoords);
          _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)));
        }
      }
    }
  }

  LatLngBounds _calculateBounds(List<Event> events) {
    double minLat = events.first.venue.latitude!;
    double maxLat = events.first.venue.latitude!;
    double minLng = events.first.venue.longitude!;
    double maxLng = events.first.venue.longitude!;

    for (final event in events) {
      if (event.venue.latitude! < minLat) minLat = event.venue.latitude!;
      if (event.venue.latitude! > maxLat) maxLat = event.venue.latitude!;
      if (event.venue.longitude! < minLng) minLng = event.venue.longitude!;
      if (event.venue.longitude! > maxLng) maxLng = event.venue.longitude!;
    }

    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  List<Marker> _buildMarkers() {
    return _filteredEvents
        .where((event) => event.venue.latitude != null && event.venue.longitude != null)
        .map((event) => Marker(
              point: LatLng(event.venue.latitude!, event.venue.longitude!),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showEventBottomSheet(event),
                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ))
        .toList();
  }

  void _showEventBottomSheet(Event event) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Lieu: ${event.venue.name}'),
            Text('Ville: ${event.venue.city}'),
            Text('Date: ${event.eventDate}'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailView(event: event)));
                },
                child: const Text('Voir les détails'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche d\'événements'),
        actions: [
          IconButton(
            icon: Icon(_showList ? Icons.map : Icons.list),
            onPressed: () {
              setState(() => _showList = !_showList);
              if (!_showList && _selectedCountry != null) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  _mapController.move(LatLng(_selectedCountry!.latitude, _selectedCountry!.longitude), 6);
                });
              } else if (!_showList) {
                _moveToFilteredEvents();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Rechercher par nom, lieu ou ville...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: _filterEvents,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Country>(
                        value: _selectedCountry,
                        decoration: const InputDecoration(
                          labelText: 'Filtrer par pays',
                          prefixIcon: Icon(Icons.flag),
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<Country>(
                            value: null,
                            child: Text('États-Unis (par défaut)'),
                          ),
                          ..._availableCountries.map((country) => DropdownMenuItem<Country>(
                            value: country,
                            child: Text('${country.name} (${country.code})'),
                          )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value;
                            _searchController.clear();
                          });
                          _loadEvents(value?.code);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(child: _showList ? _buildEventList() : _buildMap()),
              ],
            ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: const MapOptions(
        initialCenter: LatLng(39.8283, -98.5795),
        initialZoom: 4,
        minZoom: 3,
        maxZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.eventify',
        ),
        MarkerLayer(markers: _buildMarkers()),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      itemCount: _filteredEvents.length,
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        return EventCard(
          event: event,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventDetailView(event: event)),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}