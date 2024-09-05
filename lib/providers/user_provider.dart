import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<User> _users = [];
  List<User> get users => _users;

  UserProvider() {
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      _users = snapshot.docs.map((doc) => User.fromDocument(doc)).toList();
      notifyListeners();
    } catch (e) {
      // Gérer les erreurs ici
      print('Error fetching users: $e');
    }
  }

  Future<void> addUser(User user) async {
    try {
      await _firestore.collection('users').add(user.toMap());
      _fetchUsers(); // Met à jour la liste après ajout
    } catch (e) {
      // Gérer les erreurs ici
      print('Error adding user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
      _fetchUsers(); // Met à jour la liste après modification
    } catch (e) {
      // Gérer les erreurs ici
      print('Error updating user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      _fetchUsers(); // Met à jour la liste après suppression
    } catch (e) {
      // Gérer les erreurs ici
      print('Error deleting user: $e');
    }
  }
}
