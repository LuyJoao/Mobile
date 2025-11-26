import 'package:flutter/material.dart';
import '../models/computer_model.dart';
import '../database/database_helper.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  final List<Map<String, dynamic>> recommendations = const [
    {
      'title': 'Jogos Leves (Intel/RTX)',
      'cpu': 'Intel Core i3-13100F',
      'gpu': 'NVIDIA RTX 3050 (8GB)',
      'ram': '16 GB DDR4 3200MHz',
      'details': 'Roda jogos populares em 1080p com taxas de quadros confortáveis. Baixo custo.',
      'color': '#4CAF50', // Verde
      'os': 'Windows 10 Home',
      'storage_type': 'SSD',
      'ssd_count': 1,
      'hd_count': 0,
      'motherboard': 'H610M',
      'power_supply': '500W 80 Plus White',
    },
    {
      'title': 'Jogos Leves (AMD/Integrada)',
      'cpu': 'AMD Ryzen 5 5600G',
      'gpu': 'Integrada (Radeon Vega 7)',
      'ram': '16 GB DDR4 3200MHz (Dual Channel)',
      'details': 'Excelente para jogos leves sem a necessidade de placa de vídeo dedicada. Baixíssimo custo inicial.',
      'color': '#4CAF50', // Verde
      'os': 'Windows 10 Home',
      'storage_type': 'SSD',
      'ssd_count': 1,
      'hd_count': 0,
      'motherboard': 'A520M',
      'power_supply': '450W Padrão',
    },
    {
      'title': 'Jogos Médios (Intel/RTX)',
      'cpu': 'Intel Core i5-13400F',
      'gpu': 'NVIDIA RTX 4060 (8GB)',
      'ram': '32 GB DDR4 3600MHz',
      'details': 'Foco em performance estável em 1080p Ultra. Boa margem para multitarefa.',
      'color': '#FFC107', // Amarelo
      'os': 'Windows 11 Home',
      'storage_type': 'SSD',
      'ssd_count': 1,
      'hd_count': 0,
      'motherboard': 'B760M',
      'power_supply': '650W 80 Plus Bronze',
    },
    {
      'title': 'Jogos Médios (AMD/Radeon)',
      'cpu': 'AMD Ryzen 5 7600X',
      'gpu': 'AMD Radeon RX 7600 (8GB)',
      'ram': '32 GB DDR5 5600MHz',
      'details': 'Plataforma moderna (AM5) com ótimo custo-benefício para games AAA.',
      'color': '#FFC107', // Amarelo
      'os': 'Windows 11 Home',
      'storage_type': 'SSD',
      'ssd_count': 1,
      'hd_count': 0,
      'motherboard': 'B650',
      'power_supply': '750W 80 Plus Gold',
    },
    {
      'title': 'Jogos Pesados (Intel/RTX)',
      'cpu': 'Intel Core i7-14700K',
      'gpu': 'NVIDIA RTX 4070 Ti (12GB)',
      'ram': '32 GB DDR5 6000MHz',
      'details': 'Máxima performance para 1440p High Refresh Rate e 4K. Ideal para stream e criadores.',
      'color': '#D32F2F', // Vermelho
      'os': 'Windows 11 Pro',
      'storage_type': 'SSD e HD',
      'ssd_count': 2,
      'hd_count': 1,
      'motherboard': 'Z790',
      'power_supply': '850W 80 Plus Gold',
    },
    {
      'title': 'Jogos Pesados (AMD/Radeon)',
      'cpu': 'AMD Ryzen 9 7900X',
      'gpu': 'AMD Radeon RX 7800 XT (16GB)',
      'ram': '64 GB DDR5 6000MHz',
      'details': 'Alto número de núcleos e VRAM para resoluções extremas e multitarefas pesadas.',
      'color': '#D32F2F', // Vermelho
      'os': 'Windows 11 Pro',
      'storage_type': 'SSD e HD',
      'ssd_count': 2,
      'hd_count': 1,
      'motherboard': 'X670E',
      'power_supply': '1000W 80 Plus Platinum',
    },
    {
      'title': 'Desenvolvimento e Programação (Linux)',
      'cpu': 'Intel Core i5-13600K ou AMD Ryzen 7 7700',
      'gpu': 'NVIDIA RTX 3060 (12GB)',
      'ram': '32 GB DDR5 6000MHz',
      'details': 'Ótimo equilíbrio entre núcleos e VRAM para máquinas virtuais, compilação de código e trabalho gráfico. Foco em estabilidade Linux.',
      'color': '#1976D2', // Azul Escuro
      'os': 'Linux (Ubuntu/Pop!_OS)',
      'storage_type': 'SSD',
      'ssd_count': 1,
      'hd_count': 0,
      'motherboard': 'B760 / B650',
      'power_supply': '750W 80 Plus Gold',
    },
  ];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _saveRecommendation(Map<String, dynamic> rec) async {
    final computerToSave = Computer(
      id: null,
      name: 'Recomendação: ${rec['title']}',
      processor: rec['cpu'],
      gpu: rec['gpu'],
      ram: rec['ram'],
      operatingSystem: rec['os'],
      
      powerSupply: rec['power_supply'],
      motherboard: rec['motherboard'],
      caseModel: null,
      
      storageType: rec['storage_type'],
      ssdCount: rec['ssd_count'],
      hdCount: rec['hd_count'],
      imagePath: null,
      isComplete: false,
    );

    try {
      await _dbHelper.insertComputer(computerToSave);
      _showMessage('Build "${rec['title']}" salvo como RASCUNHO (Falta Gabinete)!');
    } catch (e) {
      _showMessage('Erro ao salvar o build: $e');
    }
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).hintColor),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendações de Builds'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: recommendations.map((rec) {
          final color = Color(int.parse(rec['color']!.substring(1, 7), radix: 16) + 0xFF000000);
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rec['title']!,
                    style: theme.textTheme.headlineMedium?.copyWith(color: color, fontSize: 20),
                  ),
                  const Divider(),

                  _buildDetailRow(context, Icons.speed, 'Processador', rec['cpu']),
                  _buildDetailRow(context, Icons.developer_board, 'Placa de Vídeo', rec['gpu']),
                  _buildDetailRow(context, Icons.memory, 'Memória RAM', rec['ram']),
                  _buildDetailRow(context, Icons.computer, 'Sistema Operacional', rec['os']),
                  _buildDetailRow(context, Icons.electric_bolt, 'Fonte', rec['power_supply']),
                  _buildDetailRow(context, Icons.sd_storage, 'Armazenamento', '${rec['ssd_count']}x SSD / ${rec['hd_count']}x HD'),

                  const SizedBox(height: 12),
                  
                  Text(
                    rec['details']!,
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _saveRecommendation(rec),
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar Build como Rascunho'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color, 
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}