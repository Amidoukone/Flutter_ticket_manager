import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket.dart';
import 'create_ticket_screen.dart';
import 'ticket_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        backgroundColor: const Color(0xFF128C7E), // Couleur verte plus foncée
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateTicketScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Ticket>>(
        stream: ticketProvider.ticketsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun ticket disponible'));
          }

          // Trier les tickets par ordre décroissant de timestamp (plus récent en premier)
          final tickets = snapshot.data!..sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFFF1F8E9), // Couleur de fond douce pour la carte
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    ticket.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1B5E20), // Couleur verte foncée pour le titre
                    ),
                  ),
                  subtitle: Text(
                    'Catégorie: ${ticket.category} - Statut: ${ticket.status}',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  trailing: userId == ticket.userId
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (ticket.status != 'Résolu') // Permet de modifier seulement si non résolu
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF1B5E20)), // Icône verte
                                onPressed: () => _editTicket(context, ticket),
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent), // Icône rouge pour supprimer
                              onPressed: () => _confirmDelete(context, ticket),
                            ),
                          ],
                        )
                      : null,
                  onTap: () => _showTicketDetail(context, ticket),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _editTicket(BuildContext context, Ticket ticket) {
    final titleController = TextEditingController(text: ticket.title);
    final descriptionController = TextEditingController(text: ticket.description);
    final categoryController = TextEditingController(text: ticket.category);

    showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le Ticket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF128C7E), // Bouton vert foncé
              ),
              onPressed: () {
                Navigator.of(context).pop({
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'category': categoryController.text,
                });
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    ).then((updatedData) async {
      if (updatedData != null) {
        final updatedTicket = Ticket(
          ticketId: ticket.ticketId,
          title: updatedData['title']!,
          description: updatedData['description']!,
          category: updatedData['category']!,
          status: ticket.status,
          createdAt: ticket.createdAt,
          responses: ticket.responses,
          userId: ticket.userId,
          timestamp: ticket.timestamp,
        );
        await Provider.of<TicketProvider>(context, listen: false).updateTicket(updatedTicket);
      }
    });
  }

  void _confirmDelete(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation de suppression'),
          content: const Text('Voulez-vous vraiment supprimer ce ticket ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Couleur rouge pour le bouton de suppression
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTicket(context, ticket.ticketId);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTicket(BuildContext context, String ticketId) async {
    await Provider.of<TicketProvider>(context, listen: false).deleteTicket(ticketId);
  }

  void _showTicketDetail(BuildContext context, Ticket ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDetailScreen(ticket: ticket),
      ),
    );
  }
}
