import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/character_detail_model.dart';
import '../services/character_service.dart';

const Color primaryRed = Color(0xFF8B0000);
const Color accentGold = Color(0xFFFFB703);
const Color primaryDarkBlue = Color(0xFF053F5E);

class CharacterDetailPage extends StatefulWidget {
  final int characterId;

  const CharacterDetailPage({super.key, required this.characterId});

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  Future<CharacterDetail>? _characterDetailFuture;
  
  @override
  void initState() {
    super.initState();
    _characterDetailFuture = CharacterService().fetchCharacterDetails(widget.characterId);
  }

  Widget _buildDetailRow({required ThemeData theme, required String label, required String value, bool isBounty = false}) {
    final textColor = isBounty ? accentGold : Colors.black87;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryDarkBlue,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: isBounty ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionCard({required ThemeData theme, required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: accentGold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: accentGold, size: 20),
              ],
            ),
            const Divider(color: Colors.grey, height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Personagem'),
        backgroundColor: primaryRed,
      ),
      body: FutureBuilder<CharacterDetail>(
        future: _characterDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: accentGold));
          } 
          
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Nenhum detalhe encontrado.', style: TextStyle(color: Colors.white)));
          }

          final character = snapshot.data!;
          final translatedStatus = character.status.toLowerCase() == 'vivant' ? 'Vivo' : character.status; 
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    character.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 32, 
                      fontWeight: FontWeight.w900, 
                      color: primaryRed,
                      shadows: [
                        const Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 2)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                _buildSectionCard(
                  theme: theme,
                  title: 'Informações Básicas',
                  icon: Icons.info_outline_rounded,
                  children: [
                    _buildDetailRow(theme: theme, label: 'Cargo', value: character.job),
                    _buildDetailRow(theme: theme, label: 'Status', value: translatedStatus),
                    _buildDetailRow(theme: theme, label: 'Recompensa', value: character.bounty, isBounty: true),
                  ],
                ),
                if (character.fruit != null) 
                  _buildSectionCard(
                    theme: theme,
                    title: 'Akuma no Mi 🍎',
                    icon: Icons.eco_rounded,
                    children: [
                      _buildDetailRow(theme: theme, label: 'Nome', value: character.fruit!.name),
                      _buildDetailRow(theme: theme, label: 'Tipo', value: character.fruit!.type),
                      const Divider(),
                      Text(
                        'Descrição:',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: primaryDarkBlue),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        character.fruit!.description,
                        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black87, height: 1.4),
                      ),
                    ],
                  ),
                if (character.crew != null) 
                  _buildSectionCard(
                    theme: theme,
                    title: 'Tripulação 🏴‍☠️',
                    icon: Icons.group_rounded,
                    children: [
                      _buildDetailRow(theme: theme, label: 'Nome', value: character.crew!.name),
                      _buildDetailRow(theme: theme, label: 'Nome em Romanji', value: character.crew!.romanName),
                      _buildDetailRow(theme: theme, label: 'Recompensa Total', value: character.crew!.totalBounty, isBounty: true),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
