import 'package:eventify/views/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../views/widgets/event_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final EventService _apiService = EventService();
  late Future<List<Event>> _futureevents;

  @override
  void initState() {
    super.initState();
    _futureevents = _apiService.getEvents();
  }

  // Méthode pour rafraîchir les données
  Future<void> _refreshevents() async {
    setState(() {
      _futureevents = _apiService.getEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Evenements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshevents,
          ),
        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: _futureevents,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshevents,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucun evenement disponible'),
            );
          }

          final events = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshevents,
            child: ListView.builder(
              itemCount: events.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final event = events[index];
                return EventCard(event: event);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}