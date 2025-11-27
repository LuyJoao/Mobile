import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/fruit_model.dart';
import '../services/fruit_service.dart';
import 'fruit_detail_page.dart';

const Color accentGreenLime = Color(0xFF4BC073);
const Color primaryDarkBlue = Color(0xFF053F5E);

class FruitListPage extends StatefulWidget {
  const FruitListPage({super.key});

  @override
  State<FruitListPage> createState() => _FruitListPageState();
}

class _FruitListPageState extends State<FruitListPage> {
  Future<List<Fruit>>? _fruitListFuture;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _fruitListFuture = FruitService().fetchFruits();
  }

  List<Fruit> _filterFruits(List<Fruit> fruits) {
    if (_searchText.isEmpty) {
      return fruits;
    }
    return fruits.where((fruit) =>
        fruit.name.toLowerCase().contains(_searchText.toLowerCase()) ||
        fruit.type.toLowerCase().contains(_searchText.toLowerCase())).toList();
  }

  Widget _buildFruitTile(Fruit fruit) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: ListTile(
        leading: Icon(Icons.eco_rounded, color: accentGreenLime),
        title: Text(
          fruit.name,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: primaryDarkBlue),
        ),
        subtitle: Text(
          'Tipo: ${fruit.type} | Nome em Romanji: ${fruit.romanName}',
          style: const TextStyle(color: Colors.black87),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akuma no Mi 🍎'),
        backgroundColor: accentGreenLime,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Pesquisar Akuma no Mi...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Fruit>>(
              future: _fruitListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: accentGreenLime));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar dados: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhuma Akuma no Mi encontrada.', style: TextStyle(color: Colors.white)));
                }

                final filteredFruits = _filterFruits(snapshot.data!);

                if (filteredFruits.isEmpty) {
                  return const Center(child: Text('Nenhum resultado para a busca.', style: TextStyle(color: Colors.white)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredFruits.length,
                  itemBuilder: (context, index) {
                    return _buildFruitTile(filteredFruits[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}