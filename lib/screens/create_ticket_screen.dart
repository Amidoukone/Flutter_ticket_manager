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
        backgroundColor: const Color(0xFF128C7E), // Couleur verte plus foncée
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Titre',
                labelStyle: const TextStyle(color: Color(0xFF1B5E20)), // Couleur verte foncée
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF128C7E), width: 2.0), // Bordure verte foncée
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: Color(0xFF1B5E20)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF128C7E), width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3, // Permet plus d'espace pour la description
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Catégorie',
                labelStyle: const TextStyle(color: Color(0xFF1B5E20)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF128C7E), width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF128C7E), // Bouton vert foncé
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.check, color: Colors.white), // Icône avec le texte
                onPressed: createTicket,
                label: const Text(
                  'Créer',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
