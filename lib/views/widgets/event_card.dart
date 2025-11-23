import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/event.dart';
import 'info_row.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Non spécifié';
    }
      final DateTime dateTime = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('dd MMMM yyyy \'à\' HH:mm', 'fr_FR');
      return formatter.format(dateTime);
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          child: Image.network(
              event.image,
              // height : 200,
              // width: 200,
              fit: BoxFit.cover,
        )
        ),
        title: Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(formatDate(event.eventDate), style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 2),
          ],
        ),
        // trailing: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Icon(Icons.restaurant_menu, color: Colors.green.shade700),
        //     const SizedBox(height: 4),
        //     Text('${event.name}g', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        //   ],
        // ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(event.name),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoRow(label: 'ID', value: event.id),
                    InfoRow(label: 'Nom', value: event.name),
                    InfoRow(label: 'Date', value: formatDate(event.eventDate)),
                    InfoRow(label: 'Début billeterie', value: formatDate(event.salesStart)),
                    InfoRow(label: 'Fin billeterie', value: formatDate(event.salesEnd)),
                    InfoRow(label: 'Lien', value: event.url),
                    const Divider(height: 24),
                    // const Text('Informations nutritionnelles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer'))],
            ),
          );
        },
      ),
    );
  }
}
