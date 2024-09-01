// lib/models/user.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId; // ID unique de l'utilisateur
  final String name; // Nom de l'utilisateur
  final String email; // Adresse e-mail de l'utilisateur
  final String role; // Rôle de l'utilisateur (apprenant, formateur, administrateur)

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
  });

  // Convertit un document Firestore en objet UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'apprenant', // Par défaut, le rôle est "apprenant"
    );
  }

  // Convertit un objet UserModel en format Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
