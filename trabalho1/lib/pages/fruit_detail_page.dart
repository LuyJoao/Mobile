import 'package:flutter/material.dart';
import '../models/fruit_model.dart';
import '../services/fruit_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return _buildBackground(
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Detalhes da Akuma no Mi'),
          backgroundColor: Colors.purple[800],
        ),
        body: FutureBuilder<Fruit>(
          future: _fruitDetailFuture,
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

            final fruit = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      fruit.name,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple[800]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildDetailCard(
                    title: 'Informações Básicas',
                    details: {
                      'Tipo': fruit.type,
                      'Nome em Romanji': fruit.romanName,
                    },
                  ),
                  
                  _buildDetailCard(
                    title: 'Descrição',
                    details: {
                      'Detalhe': fruit.description,
                    },
                  ),
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
}