// lib/widgets/reponse_card.dart
import 'package:flutter/material.dart';

class ResponseCard extends StatelessWidget {
  final String author; // Auteur de la réponse (apprenant ou formateur)
  final String content; // Contenu de la réponse
  final DateTime timestamp; // Horodatage de la réponse

  const ResponseCard({super.key, 
    required this.author,
    required this.content,
    required this.timestamp, required response,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              author,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '${timestamp.toLocal()}'.split(' ')[0], // Formate l'horodatage pour l'afficher proprement
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
