import 'package:cloud_firestore/cloud_firestore.dart';

class Response {
  final String author;
  final String content;
  final DateTime timestamp;

  Response({
    required this.author,
    required this.content,
    required this.timestamp,
  });

  factory Response.fromMap(Map<String, dynamic> data) {
    return Response(
      author: data['author'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class Ticket {
  final String ticketId;
  final String userId;
  final String title;
  final String description;
  final String category;
  final String status;
  final DateTime timestamp;
  final List<Response> responses; // Ajout du champ responses

  Ticket({
    required this.ticketId,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.timestamp,
    this.responses = const [], required DateTime createdAt,
  });

  Ticket copyWith({
    String? ticketId,
    String? userId,
    String? title,
    String? description,
    String? category,
    String? status,
    DateTime? timestamp,
    List<Response>? responses,
  }) {
    return Ticket(
      ticketId: ticketId ?? this.ticketId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      responses: responses ?? this.responses, createdAt: DateTime.now(),
    );
  }

  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Ticket(
      ticketId: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      status: data['status'] ?? 'en attente',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      responses: (data['responses'] as List<dynamic>? ?? [])
          .map((response) => Response.fromMap(response))
          .toList(), createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
      'responses': responses.map((response) => response.toMap()).toList(),
    };
  }
}
