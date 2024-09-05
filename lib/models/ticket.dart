import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  String ticketId;
  String title;
  String description;
  String category;
  String status;
  DateTime createdAt;
  List<String> responses;
  String userId;
  DateTime timestamp;

  Ticket({
    required this.ticketId,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.responses,
    required this.userId,
    required this.timestamp,
  });

  // Convertir un document Firestore en objet Ticket
  factory Ticket.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>; // Cast des données
    return Ticket(
      ticketId: doc.id,
      title: data['title'] ?? '', // Utilisation d'une valeur par défaut vide
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      status: data['status'] ?? 'En attente', // Statut par défaut
      createdAt: data.containsKey('createdAt') // Vérifie si le champ existe
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(), // Utilise la date actuelle si le champ est manquant
      responses: List<String>.from(data['responses'] ?? []), // Assure une liste vide si manquant
      userId: data['userId'] ?? '',
      timestamp: data.containsKey('timestamp')
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(), // Utilise la date actuelle si le champ est manquant
    );
  }

  // Convertir un objet Ticket en format Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'createdAt': createdAt,
      'responses': responses,
      'userId': userId,
      'timestamp': timestamp,
    };
  }
}
