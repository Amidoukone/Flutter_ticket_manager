// lib/screens/create_ticket_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket.dart';

class CreateTicketScreen extends StatelessWidget {
  const CreateTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un Nouveau Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Catégorie'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Création d'une nouvelle instance de Ticket
                final newTicket = Ticket(
                  ticketId: '', // Sera généré par Firestore
                  title: titleController.text,
                  description: descriptionController.text,
                  category: categoryController.text,
                  status: 'en attente', // Statut par défaut
                  createdAt: DateTime.now(),
                  responses: [],
                  userId: '', timestamp: DateTime.now(), // Remplissez par l'ID de l'utilisateur actuel
                );

                // Appel de la méthode addTicket dans le TicketProvider
                Provider.of<TicketProvider>(context, listen: false)
                    .addTicket(newTicket, newTicket.title, newTicket.description, newTicket.category);
                
                // Retour à l'écran précédent après la création du ticket
                Navigator.pop(context);
              },
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
