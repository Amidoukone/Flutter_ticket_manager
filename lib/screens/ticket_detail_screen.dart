import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket.dart';

class TicketDetailScreen extends StatefulWidget {
  final Ticket ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final TextEditingController _responseController = TextEditingController();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool _hasResponded = false;

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);

    void addResponse() async {
      if (_responseController.text.isNotEmpty) {
        setState(() {
          widget.ticket.responses.add(_responseController.text);
          _hasResponded = true;
        });
        await ticketProvider.updateTicket(widget.ticket);
        _responseController.clear();
        Navigator.of(context).pop();
      }
    }

    void changeStatus(String newStatus) async {
      setState(() {
        widget.ticket.status = newStatus;
      });
      await ticketProvider.updateTicket(widget.ticket);
      if (newStatus == 'Résolu') {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Ticket'),
        backgroundColor: const Color(0xFF128C7E), // Vert foncé
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Titre: ${widget.ticket.title}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${widget.ticket.description}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Catégorie: ${widget.ticket.category}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Statut: ${widget.ticket.status}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: widget.ticket.responses.map((response) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12.0),
                      title: Text(response),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            if (!_hasResponded && widget.ticket.status != 'Résolu')
              TextField(
                controller: _responseController,
                decoration: InputDecoration(
                  labelText: 'Ajouter une réponse',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: addResponse,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (userId == widget.ticket.userId && widget.ticket.status != 'Résolu')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => changeStatus('En cours'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF128C7E), // Vert foncé pour le fond
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    ),
                    child: const Text(
                      'Marquer comme En cours',
                      style: TextStyle(color: Colors.white), // Texte blanc
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => changeStatus('Résolu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF128C7E), // Vert foncé pour le fond
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    ),
                    child: const Text(
                      'Marquer comme Résolu',
                      style: TextStyle(color: Colors.white), // Texte blanc
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
