import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/character_model.dart';
import '../services/character_service.dart';
import 'character_detail_page.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  Future<List<Character>>? _charactersFuture;
  List<Character> _allCharacters = [];
  List<Character> _filteredCharacters = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _charactersFuture = _fetchCharacters();
  }

  Future<List<Character>> _fetchCharacters() async {
    try {
      final characters = await CharacterService().fetchCharacters();
      setState(() {
        _allCharacters = characters;
        _filteredCharacters = characters;
      });
      return characters;
    } catch (e) {
      rethrow;
    }
  }

  void _filterCharacters(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCharacters = _allCharacters;
      } else {
        _filteredCharacters = _allCharacters
            .where((character) =>
                character.name.toLowerCase().contains(query.toLowerCase()) ||
                character.job.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'vivant':
      case 'alive':
      case 'living':
        return 'Vivo';
      case 'mort':
      case 'dead':
        return 'Morto';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color accentGold = Color(0xFFFFB703);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personagens de One Piece'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.person_search_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCharacters,
              style: GoogleFonts.montserrat(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Buscar Personagem',
                labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                hintText: 'Ex: Luffy, Zoro, Captain',
                hintStyle: GoogleFonts.montserrat(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor.withOpacity(0.5),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Character>>(
              future: _charactersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: accentGold));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum personagem encontrado.', style: TextStyle(color: Colors.white)));
                } else {
                  return ListView.builder(
                    itemCount: _filteredCharacters.length,
                    itemBuilder: (context, index) {
                      final character = _filteredCharacters[index];
                      final statusText = _translateStatus(character.status);
                      final statusColor = statusText == 'Morto' ? Colors.red.shade700 : Colors.green.shade600;

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: theme.primaryColor,
                            child: const Icon(Icons.person, color: Colors.white, size: 20),
                          ),
                          title: Text(
                            character.name,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.primaryColor),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                              children: [
                                TextSpan(text: '${character.job} | Status: '),
                                TextSpan(
                                  text: statusText,
                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: statusColor),
                                ),
                              ],
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black54, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CharacterDetailPage(characterId: character.id),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}