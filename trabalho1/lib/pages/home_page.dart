import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'character_list_page.dart';
import 'fruit_list_page.dart' as fruta;
const Color accentGreenLime = Color(0xFF4BC073);
const Color primaryRed = Color(0xFF8B0000); 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('One Piece API App', style: GoogleFonts.montserrat(fontWeight: FontWeight.w800)),
        backgroundColor: primaryRed,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.directions_boat_filled_rounded, color: accentGreenLime, size: 30),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          _buildFeatureCard(
            context,
            title: 'Personagens',
            subtitle: 'Busque por membros de tripulação, Marinha e mais.',
            icon: Icons.person_search_rounded,
            cardColor: primaryRed,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CharacterListPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
          _buildFeatureCard(
            context,
            title: 'Akuma no Mi',
            subtitle: 'Detalhes e tipos das Akuma no Mi (Paramecia, Zoan, Logia).',
            icon: Icons.eco_rounded,
            cardColor: accentGreenLime,
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
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color cardColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: cardColor,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: GoogleFonts.montserrat(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 20, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}