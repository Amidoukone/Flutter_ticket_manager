// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instant_ticket/models/ticket.dart';
import 'package:instant_ticket/screens/create_ticket_screen.dart';
import 'package:instant_ticket/screens/home_screen.dart';
import 'package:instant_ticket/screens/profile_screen.dart';
import 'package:instant_ticket/screens/register_screen.dart';
import 'package:instant_ticket/screens/ticket_detail_screen.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/ticket_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Options Firebase pour le Web
  const firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyAzLwBzgLuNxegnu9OVvgmJcVTtJngIbMg",
    authDomain: "instant-ticket-d7430.firebaseapp.com",
    projectId: "instant-ticket-d7430",
    storageBucket: "instant-ticket-d7430.appspot.com",
    messagingSenderId: "631641016958",
    appId: "1:631641016958:web:ac286b4de9f7b69f33a62f",
  );

  // Initialiser Firebase avec les options appropriées
  await Firebase.initializeApp(options: firebaseOptions);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
            create: (_) => TicketProvider()
              ..loadTickets()), // Charger les tickets au démarrage
      ],
      child: MaterialApp(
        title: 'Gestion de Tickets',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/create-ticket': (context) => CreateTicketScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/ticket-details': (context) => TicketDetailsScreen(
              ticket: Ticket(
                  ticketId: '',
                  userId: '',
                  title: '',
                  description: '',
                  category: '',
                  status: '',
                  timestamp: DateTime.now(),
                  createdAt: DateTime.now())),
          '/register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}
