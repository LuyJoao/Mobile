import 'package:flutter/material.dart';
import 'computer_list_page.dart';
import 'recommendation_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.asset(
              'assets/giphy.gif',
              height: 40,
              width: 40,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildMenuItem(
            context,
            title: 'Meus PCs Cadastrados',
            subtitle: 'Gerencie e visualize seus builds salvos (CRUD Local).',
            icon: Icons.storage,
            color: Colors.blueGrey.shade700,
            targetPage: const ComputerListPage(),
          ),
          const SizedBox(height: 16),
          
          _buildMenuItem(
            context,
            title: 'Recomendações de Builds',
            subtitle: 'Sugestões para jogos, trabalho e renderização.',
            icon: Icons.lightbulb_outline,
            color: Colors.green.shade700,
            targetPage: const RecommendationPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget targetPage,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 35, color: color),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}