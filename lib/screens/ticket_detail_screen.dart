// lib/screens/ticket_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket.dart';
import '../widgets/response_card.dart';

class TicketDetailsScreen extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final responseController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ticket.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(ticket.description),
            const SizedBox(height: 20),
            Text('Catégorie : ${ticket.category}'),
            const SizedBox(height: 20),
            Text('Statut : ${ticket.status}'),
            Expanded(
              child: ListView.builder(
                itemCount: ticket.responses.length,
                itemBuilder: (context, index) {
                  final response = ticket.responses[index];
                  return ResponseCard(
                    author: response.author, 
                    content: response.content, 
                    timestamp: response.timestamp, response: null, // Assurez-vous que timestamp est de type DateTime
                  );
                },
              ),
            ),
            if (ticket.status != 'Résolu')
              TextField(
                controller: responseController,
                decoration: const InputDecoration(labelText: 'Ajouter une réponse'),
              ),
            const SizedBox(height: 10),
            if (ticket.status != 'Résolu')
              ElevatedButton(
                onPressed: () {
                  Provider.of<TicketProvider>(context, listen: false).addResponse(
                    ticket.ticketId,
                    responseController.text,
                  );
                  responseController.clear();
                },
                child: const Text('Répondre'),
              ),
          ],
        ),
      ),
    );
  }
}
