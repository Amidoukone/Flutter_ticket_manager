// lib/widgets/ticket_card.dart
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../models/ticket.dart'; // Assurez-vous que le fichier du modèle Ticket est importé

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onTicketClicked; // Callback pour gérer l'action lors du clic sur le ticket

  const TicketCard({
    required this.ticket,
    required this.onTicketClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTicketClicked, // Appel lorsque le ticket est cliqué
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                ticket.description,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Catégorie: ${ticket.category}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Statut: ${ticket.status}',
                    style: TextStyle(
                      fontSize: 14,
                      color: ticket.status == 'Résolu'
                          ? Colors.green
                          : (ticket.status == 'En cours'
                              ? Colors.orange
                              : Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Exemple d'action : "Prise en charge" pour les formateurs
                    // Vous pouvez implémenter une logique pour changer l'état du ticket ici
                  },
                  child: const Text('Prise en charge'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
