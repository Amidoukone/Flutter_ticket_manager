// lib/providers/auth_provider.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get user => _firebaseAuth.currentUser;

  /// Login method for signing in with email and password
  Future<void> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  /// SignUp method for registering a new user
  Future<void> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } catch (e) {
      throw Exception('Erreur d\'inscription: ${e.toString()}');
    }
  }

  /// Logout method to sign out the current user
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      notifyListeners();
    } catch (e) {
      throw Exception('Erreur lors de la déconnexion: ${e.toString()}');
    }
  }
}
