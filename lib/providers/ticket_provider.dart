import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket.dart';

class TicketProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Utilisation d'un Stream pour écouter les changements en temps réel
  Stream<List<Ticket>> get ticketsStream {
    return _firestore.collection('tickets').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Ticket.fromDocument(doc)).toList();
    });
  }

  // Méthode pour ajouter un ticket
  Future<void> addTicket(Ticket ticket) async {
    try {
      final docRef = await _firestore.collection('tickets').add(ticket.toMap());
      ticket.ticketId = docRef.id;
      notifyListeners();
    } catch (e) {
      print("Error adding ticket: $e");
      rethrow;
    }
  }

  // Méthode pour mettre à jour un ticket
  Future<void> updateTicket(Ticket ticket) async {
    try {
      await _firestore.collection('tickets').doc(ticket.ticketId).update(ticket.toMap());
      notifyListeners();
    } catch (e) {
      print("Error updating ticket: $e");
    }
  }

  // Méthode pour supprimer un ticket
  Future<void> deleteTicket(String ticketId) async {
    try {
      await _firestore.collection('tickets').doc(ticketId).delete();
      notifyListeners();
    } catch (e) {
      print("Error deleting ticket: $e");
    }
  }
}
