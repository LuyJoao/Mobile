import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/fruit_model.dart';
import '../services/fruit_service.dart';

const Color accentGreenLime = Color(0xFF4BC073);
const Color primaryDarkBlue = Color(0xFF053F5E);

class FruitDetailPage extends StatefulWidget {
  final int fruitId;

  const FruitDetailPage({super.key, required this.fruitId});

  @override
  State<FruitDetailPage> createState() => _FruitDetailPageState();
}

class _FruitDetailPageState extends State<FruitDetailPage> {
  Future<Fruit>? _fruitDetailFuture;

  @override
  void initState() {
    super.initState();
    _fruitDetailFuture = FruitService().fetchFruitDetails(widget.fruitId);
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value) {
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
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.black87),
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
                    color: accentGreenLime,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: accentGreenLime, size: 20),
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
        title: const Text('Detalhes da Akuma no Mi'),
        backgroundColor: accentGreenLime,
      ),
      body: FutureBuilder<Fruit>(
        future: _fruitDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: accentGreenLime));
          } 
          
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Nenhum detalhe encontrado.', style: TextStyle(color: Colors.white)));
          }

          final fruit = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    fruit.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 32, 
                      fontWeight: FontWeight.w900, 
                      color: accentGreenLime,
                      shadows: [
                        const Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 2)
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 25),

                _buildSectionCard(
                  theme: theme,
                  title: 'Informações Básicas',
                  icon: Icons.info_outline_rounded,
                  children: [
                    _buildDetailRow(theme, 'Tipo', fruit.type),
                    _buildDetailRow(theme, 'Nome em Romanji', fruit.romanName),
                  ],
                ),
                
                _buildSectionCard(
                  theme: theme,
                  title: 'Descrição',
                  icon: Icons.description_rounded,
                  children: [
                    Text(
                      fruit.description,
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black87, height: 1.4),
                    ),
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