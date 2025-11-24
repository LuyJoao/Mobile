import 'package:flutter/material.dart';
import '../models/character_detail_model.dart';
import '../services/character_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return _buildBackground(
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Detalhes do Personagem'),
          backgroundColor: Colors.red[900],
        ),
        body: FutureBuilder<CharacterDetail>(
          future: _characterDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar dados: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Nenhum detalhe encontrado.', style: TextStyle(color: Colors.white)));
            }

            final character = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Center(
                    child: Text(
                      character.name,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red[900]),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildDetailCard(
                    title: 'Informações Básicas',
                    details: {
                      'Cargo': character.job,
                      'Status': character.status,
                      'Recompensa': character.bounty,
                    },
                  ),
                  
                  if (character.fruit != null) 
                    _buildDevilFruitSection(character.fruit!),

                  if (character.crew != null) 
                    _buildCrewSection(character.crew!),
                  
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailCard({required String title, required Map<String, String> details}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...details.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                '${entry.key}: ${entry.value}',
                style: const TextStyle(fontSize: 16),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDevilFruitSection(FruitDetail fruit) {
    return _buildDetailCard(
      title: 'Akuma no Mi 🍎',
      details: {
        'Nome': fruit.name,
        'Tipo': fruit.type,
        'Descrição': fruit.description,
      },
    );
  }

  Widget _buildCrewSection(CrewDetail crew) {
    return _buildDetailCard(
      title: 'Tripulação 🏴‍☠️',
      details: {
        'Nome da Tripulação': crew.name,
        'Nome em Romanji': crew.romanName,
        'Recompensa Total': crew.totalBounty,
        'É Yonkou?': crew.isYonko,
      },
    );
  }
}