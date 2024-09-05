import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket.dart';

class CreateTicketScreen extends StatelessWidget {
  const CreateTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    void createTicket() async {
      if (titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          categoryController.text.isNotEmpty) {
        final newTicket = Ticket(
          ticketId: '', // ID sera généré par Firestore
          title: titleController.text,
          description: descriptionController.text,
          category: categoryController.text,
          status: 'En attente', // Statut par défaut
          createdAt: DateTime.now(),
          responses: [],
          userId: userId,
          timestamp: DateTime.now(),
        );

        try {
          await Provider.of<TicketProvider>(context, listen: false)
              .addTicket(newTicket);
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la création du ticket : $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tous les champs sont obligatoires')),
        );
      }
    }

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
              onPressed: createTicket,
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
