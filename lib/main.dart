import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase

import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart'; // Importez HomeScreen
import 'screens/create_ticket_screen.dart'; // Importez CreateTicketScreen
import 'providers/ticket_provider.dart'; // Importez TicketProvider
import 'providers/user_provider.dart'; // Importez UserProvider si vous avez besoin de gérer les utilisateurs

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAzLwBzgLuNxegnu9OVvgmJcVTtJngIbMg",
      authDomain: "instant-ticket-d7430.firebaseapp.com",
      projectId: "instant-ticket-d7430",
      storageBucket: "instant-ticket-d7430.appspot.com",
      messagingSenderId: "631641016958",
      appId: "1:631641016958:web:ac286b4de9f7b69f33a62f",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), // Ajout de UserProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Tickets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // Écran de connexion
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/create-ticket': (context) => const CreateTicketScreen(), // Route pour CreateTicketScreen
        // Ajouter d'autres routes si nécessaire
      },
    );
  }
}
