import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../services/character_service.dart';
import 'character_detail_page.dart';

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
    return _buildBackground(
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Personagens de One Piece 👤'),
          backgroundColor: Colors.red[900],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterCharacters,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Buscar Personagem',
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintText: 'Ex: Luffy, Zoro, Captain',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Character>>(
                future: _charactersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum personagem encontrado.', style: const TextStyle(color: Colors.white)));
                  } else {
                    return ListView.builder(
                      itemCount: _filteredCharacters.length,
                      itemBuilder: (context, index) {
                        final character = _filteredCharacters[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          elevation: 5,
                          color: Colors.white.withOpacity(0.9),
                          child: ListTile(
                            title: Text(
                              character.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                            ),
                            subtitle: Text(
                              '${character.job} | Status: ${_translateStatus(character.status)}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CharacterDetailPage(characterId: character.id!),
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
      ),
    );
  }
}