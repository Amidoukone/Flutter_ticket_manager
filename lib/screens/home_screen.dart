import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ticket_provider.dart' as ticket_provider;
import '../models/ticket.dart';
import '../screens/create_ticket_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/ticket_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<ticket_provider.TicketProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateTicketScreen()),
                );
              },
              child: const Text('Créer un Ticket'),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'En attente'),
                      Tab(text: 'En cours'),
                      Tab(text: 'Résolu'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildTicketList(ticketProvider.ticketsByStatus('en attente')),
                        _buildTicketList(ticketProvider.ticketsByStatus('en cours')),
                        _buildTicketList(ticketProvider.ticketsByStatus('résolu')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketList(List<Ticket> tickets) {
    if (tickets.isEmpty) {
      return const Center(child: Text('Aucun ticket disponible.'));
    }
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return ListTile(
          title: Text(ticket.title),
          subtitle: Text(ticket.description),
          trailing: Text(ticket.status),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TicketDetailsScreen(ticket: ticket),
              ),
            );
          },
        );
      },
    );
  }
}
