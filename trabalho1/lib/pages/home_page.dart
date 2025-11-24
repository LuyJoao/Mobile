import 'package:flutter/material.dart';
import 'character_list_page.dart';
import 'fruit_list_page.dart' as fruta;

Widget _buildBackground(Widget child) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF003049),
          Color(0xFF005f73),
          Color(0xFF0A9396),
        ],
      ),
    ),
    child: child,
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBackground(
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('One Piece API App'),
          backgroundColor: const Color(0xFF003049),
          leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(Icons.directions_boat, color: Colors.white, size: 30),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _buildFeatureCard(
              context,
              title: 'Personagens',
              subtitle: 'Busque por membros de tripulação, Marinha e mais.',
              icon: Icons.person_search,
              color: Colors.red.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CharacterListPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              title: 'Akuma no Mi',
              subtitle: 'Detalhes e tipos das Akuma no Mi (Paramecia, Zoan, Logia).',
              icon: Icons.apple,
              color: Colors.purple.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const fruta.FruitListPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: color.withOpacity(0.95),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}