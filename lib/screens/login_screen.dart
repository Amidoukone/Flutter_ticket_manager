// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _validateEmail(emailController.text) ? null : 'Veuillez entrer un email valide',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!_validateEmail(emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez entrer un email valide.')),
                  );
                  return;
                }

                try {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .login(emailController.text, passwordController.text);
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Erreur de connexion'),
                        content: Text(e.toString()), // Afficher une erreur descriptive
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Se connecter'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!_validateEmail(emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez entrer un email valide.')),
                  );
                  return;
                }

                try {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .signUp(emailController.text, passwordController.text);
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Erreur d\'inscription'),
                        content: Text(e.toString()), // Afficher une erreur descriptive
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
