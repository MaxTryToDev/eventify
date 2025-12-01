import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../models/event.dart';
import '../models/country.dart';
import '../services/event_service.dart';
import '../services/location_service.dart';
import 'widgets/event_card.dart';
import 'event_detail_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final EventService _eventService = EventService();
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  List<Country> _countries = [];
  Country? _selectedCountry;
  Position? _currentPosition;
  bool _isLoading = false;
  bool _showMap = false;
  double _radiusKm = 50.0;

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
      });
      if (position != null) {
        _searchNearbyEvents();
      }
    } catch (e) {
      print('Erreur géolocalisation: $e');
    }
  }

  Future<void> _loadCountries() async {
    setState(() {
      _countries = [
        Country(code: 'US', name: 'États-Unis', latitude: 39.8283, longitude: -98.5795),
        Country(code: 'FR', name: 'France', latitude: 46.2276, longitude: 2.2137),
        Country(code: 'GB', name: 'Royaume-Uni', latitude: 55.3781, longitude: -3.4360),
        Country(code: 'DE', name: 'Allemagne', latitude: 51.1657, longitude: 10.4515),
        Country(code: 'CA', name: 'Canada', latitude: 56.1304, longitude: -106.3468),
      ];
    });
  }

  Future<void> _searchNearbyEvents() async {
    if (_currentPosition == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final events = await _eventService.getEvents('US');
      final nearbyEvents = events.where((event) {
        if (event.venue.latitude == null || event.venue.longitude == null) return false;
        
        final distance = _locationService.calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          event.venue.latitude!,
          event.venue.longitude!,
        );
        
        return distance <= _radiusKm;
      }).toList();

      setState(() {
        _events = nearbyEvents;
        _filteredEvents = nearbyEvents;
        _isLoading = false;
      });

      if (_showMap && nearbyEvents.isNotEmpty) {
        _mapController.move(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude), 
          10
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Future<void> _searchEvents() async {
    if (_selectedCountry == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final events = await _eventService.getEvents(_selectedCountry!.code);
      setState(() {
        _events = events;
        _filteredEvents = events;
        _isLoading = false;
      });

      if (_showMap && events.isNotEmpty) {
        _mapController.move(
          LatLng(_selectedCountry!.latitude, _selectedCountry!.longitude), 
          6
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];
    
    // Marqueur position actuelle
    if (_currentPosition != null) {
      markers.add(
        Marker(
          point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          child: const Icon(
            Icons.my_location,
            color: Colors.blue,
            size: 30,
          ),
        ),
      );
    }

    // Marqueurs événements
    markers.addAll(
      _filteredEvents
          .where((event) => event.venue.latitude != null && event.venue.longitude != null)
          .map((event) => Marker(
                point: LatLng(event.venue.latitude!, event.venue.longitude!),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailView(event: event),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ))
          .toList(),
    );

    return markers;
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentPosition != null 
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : const LatLng(39.8283, -98.5795),
        initialZoom: 10.0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rechercher des événements"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showMap ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _showMap = !_showMap;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_currentPosition != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text('Rayon de recherche: '),
                      Text('${_radiusKm.round()} km'),
                    ],
                  ),
                  Slider(
                    value: _radiusKm,
                    min: 10,
                    max: 200,
                    divisions: 19,
                    onChanged: (value) {
                      setState(() {
                        _radiusKm = value;
                      });
                    },
                    onChangeEnd: (value) {
                      _searchNearbyEvents();
                    },
                  ),
                  const Divider(),
                ],
                DropdownButtonFormField<Country>(
                  decoration: const InputDecoration(
                    labelText: 'Ou sélectionner un pays',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCountry,
                  items: _countries.map((country) {
                    return DropdownMenuItem<Country>(
                      value: country,
                      child: Text(country.name),
                    );
                  }).toList(),
                  onChanged: (Country? newValue) {
                    setState(() {
                      _selectedCountry = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (_currentPosition != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _searchNearbyEvents,
                          icon: const Icon(Icons.my_location),
                          label: const Text('Près de moi'),
                        ),
                      ),
                    if (_currentPosition != null && _selectedCountry != null)
                      const SizedBox(width: 8),
                    if (_selectedCountry != null)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _searchEvents,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(_selectedCountry!.name),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _showMap
                ? _buildMap()
                : _filteredEvents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_currentPosition == null) ...[
                              const Icon(Icons.location_off, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text(
                                'Géolocalisation non disponible',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                            ],
                            const Text(
                              'Aucun événement trouvé.\nSélectionnez un pays ou activez la géolocalisation.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = _filteredEvents[index];
                          return EventCard(
                            event: event,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailView(event: event),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}