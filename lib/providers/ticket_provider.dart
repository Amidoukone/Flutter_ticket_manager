import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket.dart';

class TicketProvider with ChangeNotifier {
  List<Ticket> _tickets = [];

  List<Ticket> get tickets => _tickets;

  // Méthode pour filtrer les tickets par statut
  List<Ticket> ticketsByStatus(String status) {
    return _tickets.where((ticket) => ticket.status.toLowerCase() == status.toLowerCase()).toList();
  }

  // Chargement des tickets depuis Firestore
  Future<void> loadTickets() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tickets').get();
      _tickets = querySnapshot.docs.map((doc) => Ticket.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Erreur lors du chargement des tickets: $e');
    }
  }

// Méthode pour ajouter un nouveau ticket
Future<void> addTicket(Ticket ticket, String title, String description, String category) async {
  try {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('tickets').add(ticket.toMap());
    Ticket newTicket = ticket.copyWith(ticketId: docRef.id);
    _tickets.add(newTicket);
    notifyListeners();
  } catch (e) {
    print('Erreur lors de l\'ajout du ticket: $e');
  }
}


  // Ajout de réponse au ticket
  Future<void> addResponse(String ticketId, String content) async {
    final ticketIndex = _tickets.indexWhere((ticket) => ticket.ticketId == ticketId);
    if (ticketIndex == -1) return;
    // Logique d'ajout de réponse à Firestore
    // Après ajout de réponse, notifier les changements
    notifyListeners();
  }
}
