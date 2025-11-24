import 'package:flutter/material.dart';
import '../models/fruit_model.dart';
import '../services/fruit_service.dart';
import 'fruit_detail_page.dart';

class FruitListPage extends StatefulWidget {
  const FruitListPage({super.key});

  @override
  State<FruitListPage> createState() => _FruitListPageState();
}

class _FruitListPageState extends State<FruitListPage> {
  List<Fruit> _allFruits = [];
  List<Fruit> _filteredFruits = [];
  bool _isLoading = true;
  final FruitService _service = FruitService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      _allFruits = await _service.fetchFruits();
      _filterFruits('');
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterFruits(String query) {
    final searchText = query.toLowerCase();
    setState(() {
      if (searchText.isEmpty) {
        _filteredFruits = _allFruits;
      } else {
        _filteredFruits = _allFruits.where((fruit) {
          final fruitNameLower = fruit.name.toLowerCase();
          final romanNameLower = fruit.romanName.toLowerCase();

          return fruitNameLower.contains(searchText) ||
              romanNameLower.contains(searchText);
        }).toList();
      }
      _isLoading = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Akuma no Mi 🍎'),
        // Cor da AppBar das frutas
        backgroundColor: Colors.purple[800],
      ),
      body: _buildBackground(
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: _filterFruits,
                decoration: const InputDecoration(
                  labelText: 'Pesquisar Akuma no Mi...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredFruits.isEmpty
                      ? const Center(child: Text('Nenhuma Akuma no Mi encontrada.', style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: _filteredFruits.length,
                          itemBuilder: (context, index) {
                            final fruit = _filteredFruits[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.apple_outlined),
                                ),
                                title: Text(fruit.name),
                                subtitle: Text(
                                  'Tipo: ${fruit.type} | Nome em Romanji: ${fruit.romanName}',
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FruitDetailPage(fruitId: fruit.id),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}